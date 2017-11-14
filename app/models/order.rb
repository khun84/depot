# require 'active_model/serializers/xml'
require 'pago'
require 'ostruct'
class Order < ApplicationRecord
  # include ActiveModel::Serializers::Xml
  enum pay_type: {
          "Check"=>0,
          "Credit Card" => 1,
          "Purchase Order" => 2
  }
  enum status: {
          "New"=>0,
          "Paid"=>1,
          "Shipped"=>2,
          "Cancelled"=>3
  }
  validates :name, :email, :address, presence: true
  validates :pay_type, inclusion: pay_types.keys

  has_many :line_items, dependent: :destroy

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      # nullify the cart id so that the line item wont raise foreign key error
      # when it is deleted after order success
      item.cart_id = nil
      line_items << item
    end
  end

  def charge!(pay_type_params)
    payment_details = {}
    payment_method = nil

    case pay_type
      when "Check"
        payment_method = :check
        payment_details[:routing] = pay_type_params[:routing_number]
        payment_details[:account] = pay_type_params[:account_number]
      when "Credit card"
        payment_method = :credit_card
        month, year = pay_type_params[:expiration_date].split(//)
        payment_details[:cc_num] = pay_type_params[:credit_card_number]
        payment_details[:expiration_month] = month
        payment_details[:expiration_year] = year
      when "Purchase order"
        payment_method = :po
        payment_details[:po_num] = pay_type_params[:po_number]
    end

    begin
      payment_result = Pago.make_payment(
                                   order_id: id,
                                   payment_method: payment_method,
                                   payment_details: payment_details
      )
    rescue
      self.errors[:status] << "Unknown payment method."
      OrderMailer.payment_error(self)
      return false
    end

    if payment_result.succeeded?
      OrderMailer.received(self)
      self.status = "Paid"
      self.save
      return true
    else
      self.errors[:status] << "Unable to process payment. Please check your payment detail."
      OrderMailer.payment_error(self)
      return false
    end
  end

end

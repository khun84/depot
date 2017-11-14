class LineItem < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :order, optional: true
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def update_quantity(params)
    self.quantity+=params[:quantity].to_i

    if self.quantity == 0
      return self.destroy
    else
      return self.save
    end

  end

end

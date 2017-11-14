class CombineItemsInCart < ActiveRecord::Migration[5.1]
  def up
    Cart.all.each do |cart|
      # group sum the line item in cart
      sum = cart.line_items.group(:product_id).sum(:quantity)

      sum.each do |product_id, quantity|
        # if more than 1 item, create a new aggregated item and delete existing item
        if quantity > 1
          cart.line_items.where(product_id: product_id).delete_all
          item = cart.line_items.new(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    LineItem.where('quantity > 1').each do |line_item|
      # create new line item for each quantity
      line_item.quantity.times do
        LineItem.create(
                cart_id: line_item.cart_id,
                product_id: line_item.product_id,
                quantity: 1)
      end
      # delete the existing line item
      line_item.destroy
    end
  end
end

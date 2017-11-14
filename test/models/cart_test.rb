require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :carts, :products, :line_items
  # test "the truth" do
  #   assert true
  # end
  # test "the truth" do
  #   assert true
  # end

  test 'should copy price to line item when add product' do

    current_item = carts(:one).add_product(products(:ruby))

    assert current_item.price == products(:ruby).price
  end

  test "should'nt combine unique product" do
    cart = Cart.create
    cart.add_product(products(:one)).save
    cart.add_product(products(:ruby)).save

    assert cart.line_items.count == 2

  end

  test 'should combine same product into 1 line item' do
    cart = Cart.create
    cart.add_product(products(:one)).save
    cart.add_product(products(:one)).save

    assert cart.line_items.count == 1
  end
end

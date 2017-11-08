require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = build(:product, title: nil, description: nil, image_url: nil, price:nil)
    # product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test 'product price must be positive' do
    # product = Product.new
    product = build(:product, price: -1)

    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test 'image url' do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.jPG http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |image_url|
      assert build(:product, image_url: image_url).valid?, "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert build(:product, image_url: image_url).invalid?, "#{image_url} shouldn't be valid"
    end

  end

  test 'product is not valid without a unique name - i18n' do
    product = Product.new(
                             title: products(:ruby).title,
                             description: 'yy',
                             image_url: 'fred.gif',
                             price: 1
    )

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

end

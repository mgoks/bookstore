# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title: 'My Book Title', description: 'yyy',
                          image_url: 'zzz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test 'image url' do
    ok = %w[ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif ]
    bad = %w[fred.doc fred.gif/more fred.gif.more]

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} must be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} must be invalid"
    end
  end

  test 'product is not valid without a unique title' do
    product = new_product('fred.gif')
    product.title = products(:ruby).title
    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end

  test 'product is not valid without a unique title - i18n' do
    product = new_product('fred.gif')
    product.title = products(:ruby).title
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end

  test 'product title must ne at least ten characters long' do
    product_short_title = new_product('fred.gif')
    product_10_char_title = new_product('fred.gif')
    product_long_title = new_product('fred.gif')

    product_short_title.title = 'short'
    product_10_char_title.title = '1234567890'
    product_long_title.title = 'this is definitely longer than 10 characters'

    assert product_short_title.invalid?
    assert product_10_char_title.valid?
    assert product_long_title.valid?
  end

  def new_product(image_url)
    Product.new(title: 'My Book Title',
                description: 'yyy',
                price: 1,
                image_url:)
  end
end

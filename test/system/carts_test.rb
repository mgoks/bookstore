# frozen_string_literal: true

require 'application_system_test_case'

class CartsTest < ApplicationSystemTestCase
  test 'reveal and hide cart' do
    visit store_index_url
    # Initially the cart is hidden.
    refute_selector 'h2', text: 'Your Cart'
    click_on 'Add to Cart', match: :first
    assert_selector 'h2', text: 'Your Cart'
    click_on 'Empty cart' 
    refute_selector 'h2', text: 'Your Cart'
  end
end

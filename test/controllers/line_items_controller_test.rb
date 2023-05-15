# frozen_string_literal: true

require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Not the only line item in the cart
    @line_item = line_items(:ruby_line_item_in_cart_two_items)

    # Only line item in the cart
    @single_line_item = line_items(:line_item_in_cart_single_item)
  end

  test 'should get index' do
    get line_items_url
    assert_response :success
  end

  test 'should get new' do
    get new_line_item_url
    assert_response :success
  end

  test 'should create line_item' do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end
    follow_redirect!
    assert_select 'h2', 'Your Cart'
    assert_select 'td', 'Programming Ruby 1.9'
  end

  test 'should create line item via turbo-stream' do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id },
                           as: :turbo_stream
    end
    assert_response :success
    assert_match(/<tr class="line-item-highlight">/, @response.body)
  end

  test 'should show line_item' do
    get line_item_url(@line_item)
    assert_response :success
  end

  test 'should get edit' do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test 'should update line_item' do
    patch line_item_url(@line_item), params: {
      line_item: {
        product_id: @line_item.product_id
      }
    }
    assert_redirected_to store_index_url
  end

  test 'should update line item via turbo-stream' do
    # TODO
  end

  test 'should destroy line item ' do
    # Destroy the line item in cart and keep cart.
    cart = @line_item.cart
    assert cart.line_items.length > 1
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end
    assert_not cart.destroyed?
    assert_redirected_to store_index_url

    # TODO: Destroy line item and cart.
  end

  test 'should destory line item via turbo-stream' do
    # TODO
  end
end

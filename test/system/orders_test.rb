# frozen_string_literal: true

require 'application_system_test_case'

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test 'check dynamic fields' do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Check out'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Check', from: 'Pay type'
    assert has_field? 'Routing number'
    assert has_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Credit card', from: 'Pay type'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_field? 'Credit card number'
    assert has_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Purchase order', from: 'Pay type'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_field? 'Po number'
  end

  test 'check order and delivery' do
    account_number = '9786423'
    address = '123 Main Street'
    email = 'dave@example.com'
    name = 'Dave Thomas'
    pay_type = 'Check'
    routing_number = '123456'

    LineItem.delete_all
    Order.delete_all

    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Check out'
    fill_in 'Name', with: name
    fill_in 'Address', with: address
    fill_in 'Email', with: email
    select pay_type, from: 'Pay type'
    fill_in 'Routing number', with: routing_number
    fill_in 'Account number', with: account_number
    click_button 'Place order'
    assert_text 'Thank you for your order'

    # Since our ChangeOrderJob enqueues a mail job, clearing the queue once
    # isn’t enough, so we clear it twice (?)
    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first
    assert_equal name, order.name
    assert_equal address, order.address
    assert_equal email, order.email
    assert_equal pay_type, order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [email], mail.to
    assert_equal 'Mooch\'s Bookstore <noreply@moochsbookstore.com>',
                 mail[:from].value
    assert_equal "Mooch's Bookstore order confirmation", mail.subject
  end
end

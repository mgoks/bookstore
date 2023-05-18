# frozen_string_literal: true

require 'application_system_test_case'

class LineItemsTest < ApplicationSystemTestCase
  test 'highlight new line item' do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    assert page.has_css? 'table tr.line-item-highlight', count: 1
    click_on 'Add to Cart', match: :first
    assert page.has_css? 'table tr.line-item-highlight', count: 1
    click_on '-', match: :first
    assert page.has_css? 'table tr.line-item-highlight', count: 0
  end
end

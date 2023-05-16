# frozen_string_literal: true

class Order < ApplicationRecord
  enum pay_type: {
    'Check' => 0,
    'Credit card' => 1,
    'Purchase order' => 2
  }

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  # All items that belong to an Order are to be destroyed whenever the Order is
  # destroyed.
  has_many :line_items, dependent: :destroy

  def add_line_items_form_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end

# frozen_string_literal: true

require 'pago'

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

  # This method does 3 things. First, it adapts the pay_type_params to the
  # parameters that Pago requires. Second, it makes the call to Pago to collect
  # payment. Finally, it checks to see if the payment succeeded and, if so,
  # sends the confirmation email.
  def charge!(pay_type_params)
    payment_details = {}
    payment_method  = nil

    case pay_type
    when 'Check'
      payment_method = :check
      payment_details[:routing] = pay_type_params[:routing_number]
      payment_details[:account] = pay_type_params[:account_number]
    when 'Credit card'
      payment_method = :credit_card
      month, year = pay_type_params[:expiration_date].split(//)
      payment_details[:cc_num] = pay_type_params[:credit_card_number]
      payment_details[:expiration_month] = month
      payment_details[:expiration_year] = year
    when 'Purchase order'
      payment_method = :po
      payment_details[:po_num] = pay_type_params[:po_number]
    end

    payment_result = Pago.make_payment(order_id: id,
                                       payment_method:,
                                       payment_details:)
    raise payment_result.error unless payment_result.succeeded?

    OrderMailer.received(self).deliver_later
  end
end

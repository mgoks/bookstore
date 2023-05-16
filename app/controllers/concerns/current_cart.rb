# frozen_string_literal: true

module CurrentCart
  private

  # Mark set_cart private to prevent Rails from making it available as an action
  # on the controller.
  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end

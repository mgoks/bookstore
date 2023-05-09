class CombineItemsInCart < ActiveRecord::Migration[7.0]

  def up
    # Replace multiple items for a single products in a cart with a single item.
    Cart.all.each do |cart|
      # Count the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # Remove individual items.
          cart.line_items.where(product_id: product_id).delete_all

          # Replace with a single item.
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    LineItem.where('quantity>1').each do |line_item|
      line_item.quantity.times do
        LineItem.create(cart_id: line_item.cart_id, 
                        product_id: line_item.product_id, 
                        quantity: 1)
      end
      line_item.destroy
    end
  end

end
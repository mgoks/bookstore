# frozen_string_literal: true

class AddPaymentDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :routing_number, :string, null: true
    add_column :orders, :account_number, :string, null: true
    add_column :orders, :cc_number, :string, null: true
    add_column :orders, :cc_expiration_date, :string, null: true
    add_column :orders, :po_number, :string, null: true
  end
end

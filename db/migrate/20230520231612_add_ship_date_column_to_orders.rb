# frozen_string_literal: true

class AddShipDateColumnToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :ship_date, :date, null: true
  end
end
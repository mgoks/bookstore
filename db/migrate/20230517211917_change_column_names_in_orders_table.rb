# frozen_string_literal: true

class ChangeColumnNamesInOrdersTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :cc_number, :credit_card_number
    rename_column :orders, :cc_expiration_date, :expiration_date
  end
end

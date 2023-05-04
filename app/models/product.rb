# frozen_string_literal: true

class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true, length: {
    minimum: 10,
    too_short: 'title has to be at least %<count>s characters long'
  }
  validates :image_url, allow_blank: true, format: {
    with: /\.(gif|jpg|png)\z/i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01
  }
end

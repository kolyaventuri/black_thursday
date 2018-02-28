# frozen_string_literal: true

require 'time'

# Defines an item in the store
class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :item_repository

  def initialize(data, item_repository)
    ids data
    parse_dates data
    @name = data[:name]
    @description = data[:description]
    @unit_price = price_to_big_decimal data[:unit_price]
    @item_repository = item_repository
  end

  def ids(data)
    @id = data[:id].to_i
    @merchant_id = data[:merchant_id].to_i
  end

  def parse_dates(data)
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
  end

  def price_to_big_decimal(price)
    BigDecimal.new(price.to_i) / 100.0
  end

  def merchant
    @item_repository.find_merchant @merchant_id
  end
end

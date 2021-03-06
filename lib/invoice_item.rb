# frozen_string_literal: true

# Defines an InvoiceItem
class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(data, invoice_item_repository)
    ids data
    parse_times data
    @quantity = data[:quantity].to_i
    @unit_price = price_to_big_decimal data[:unit_price]
    @invoice_item_repository = invoice_item_repository
  end

  def ids(data)
    @id = data[:id].to_i
    @item_id = data[:item_id].to_i
    @invoice_id = data[:invoice_id].to_i
  end

  def parse_times(data)
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
  end

  def price_to_big_decimal(price)
    BigDecimal.new(price.to_i) / 100.0
  end

  def unit_price_to_dollars
    @unit_price
  end
end

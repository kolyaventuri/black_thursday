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

  def initialize(data)
    @id = data[:id].to_i
    @item_id = data[:item_id].to_i
    @invoice_id = data[:invoice_id].to_i
    @quantity = data[:quantity].to_i
    @unit_price = price_to_big_decimal data[:unit_price]
    parse_times data
  end

  def parse_times(data)
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
  end

  def price_to_big_decimal(price)
    BigDecimal.new(price.to_i) / 100.0
  end
end

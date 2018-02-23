# frozen_string_literal: true

require 'bigdecimal'

require_relative 'test_helper.rb'

require './lib/invoice_item.rb'
require './test/mocks/test_engine'

class InvoiceItemTest < Minitest::Test
  TIME = Time.parse '2009-02-07'
  INVOICE_ITEM_DATA = {
    id: 6,
    item_id: 7,
    invoice_id: 8,
    quantity: 1,
    unit_price: '1099',
    created_at: '2009-02-07',
    updated_at: '2009-02-07'
  }.freeze

  def setup
    @item = InvoiceItem.new(
      INVOICE_ITEM_DATA,
      MOCK_INVOICE_ITEM_REPOSITORY
    )
  end

  def test_can_create_invoice_item
    assert_instance_of InvoiceItem, @item
  end

  def test_does_store_attributes
    assert_equal 6, @item.id
    assert_equal 7, @item.item_id
    assert_equal 8, @item.invoice_id
    assert_equal 1, @item.quantity
    assert_equal BigDecimal.new(1099), @item.unit_price
    assert_equal TIME, @item.created_at
    assert_equal TIME, @item.updated_at
  end

  def test_can_get_price_in_usd
    assert_equal 10.99, @item.unit_price_to_dollars
  end
end

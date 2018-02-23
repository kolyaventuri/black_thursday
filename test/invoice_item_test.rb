require_relative 'test_helper.rb'

require './lib/invoice_item.rb'

class InvoiceItemTest < Minitest::Test
  TIME = Time.parse '2009-02-07'
  def setup
    @item = InvoiceItem.new(
      id: 6,
      customer_id: 7,
      merchant_id: 8,
      status: 'pending',
      created_at: '2009-02-07',
      updated_at: '2009-02-07'
    )
  end

  def test_can_create_invoice_item
    assert_instance_of InvoiceItem, @item
  end

  def test_does_store_attributes
    assert_equal 6, @item.id
    assert_equal 7, @item.customer_id
    assert_equal 8, @item.merchant_id
    assert_equal :pending, @item.status
    assert_equal TIME, @item.created_at
    assert_equal TIME, @item.updated_at
  end
end

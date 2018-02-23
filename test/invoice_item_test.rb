require_relative 'test_helper.rb'

require './lib/invoice_item.rb'

class InvoiceItemTest < Minitest::Test
  def setup
    @item = InvoiceItem.new
  end

  def test_can_create_invoice_item
    assert_instance_of InvoiceItem, @item
  end
end

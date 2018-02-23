require_relative 'test_helper.rb'

require './lib/invoice_item_repository.rb'
require './test/mocks/test_engine'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    @repo = InvoiceItemRepository.new './test/fixtures/invoice_items.csv',
                                      MOCK_SALES_ENGINE
  end

  def test_does_create_item_repository
    assert_instance_of InvoiceItemRepository, @repo
  end

  def test_did_load_items
    items = @repo.all
    assert_instance_of Array, items
    items.each do |item|
      assert_instance_of InvoiceItem, item
    end

    assert_equal 136.35, items[0].unit_price
  end

  def test_can_find_invoice_item_by_id
    item = @repo.find_by_id 9
    assert_instance_of InvoiceItem, item
    assert_equal 9, item.id
    assert_equal 299.73, item.unit_price
  end
end

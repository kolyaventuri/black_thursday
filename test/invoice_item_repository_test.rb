require 'bigdecimal'

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

    assert_equal BigDecimal.new(13_635), items[0].unit_price
  end

  def test_can_find_invoice_item_by_id
    item = @repo.find_by_id 9
    assert_instance_of InvoiceItem, item
    assert_equal 9, item.id
    assert_equal BigDecimal.new(29_973), item.unit_price
  end

  def test_can_find_item_by_item_id
    items = @repo.find_all_by_item_id 1
    assert_instance_of Array, items
    assert_equal 5, items.length
    items.each do |item|
      assert_instance_of InvoiceItem, item
      assert_equal 1, item.item_id
    end
  end

  def test_can_find_all_by_invoice_id
    items = @repo.find_all_by_invoice_id 2
    assert_instance_of Array, items
    assert_equal 4, items.length
    items.each do |item|
      assert_instance_of InvoiceItem, item
      assert_equal 2, item.invoice_id
    end
  end
end

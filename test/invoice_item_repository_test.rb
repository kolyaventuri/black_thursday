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
end
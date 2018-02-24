# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/customer_repository'

class SalesEngineTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv(
      items: './test/fixtures/items.csv',
      merchants: './test/fixtures/merchants.csv',
      invoices: './test/fixtures/invoices.csv',
      transactions: './test/fixtures/transactions.csv'
      invoice_items: './test/fixtures/invoice_items.csv',
      customers: './test/fixtures/customers.csv'
    )
  end

  def test_it_creates_sales_engine
    assert_instance_of SalesEngine, @se
  end

  def test_it_has_item_repository
    assert_instance_of ItemRepository, @se.items
  end

  def test_it_has_merchant_repository
    assert_instance_of MerchantRepository, @se.merchants
  end

  def test_it_has_invoice_repository
    assert_instance_of InvoiceRepository, @se.invoices
  end

  def test_it_has_transaction_repository
    assert_instance_of TransactionRepository, @se.transactions
  end
  
  def test_it_has_invoice_item_repository
    assert_instance_of InvoiceItemRepository, @se.invoice_items
  end

  def test_it_has_customer_repository
    assert_instance_of CustomerRepository, @se.customers
  end
end

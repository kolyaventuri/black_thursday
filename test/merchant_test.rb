# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant'
require_relative '../lib/invoice'
require_relative 'mocks/test_engine'

class MerchantTest < Minitest::Test
  def test_it_exists
    merchant = Merchant.new(
      {
        id: '5',
        name: 'Turing School',
        created_at: '2010-12-10'
      },
      MOCK_MERCHANT_REPOSITORY
    )

    assert_instance_of Merchant, merchant
  end

  def test_it_has_attributes
    merchant = Merchant.new(
      {
        id: '5',
        name: 'Turing School',
        created_at: '2010-12-10'
      },
      MOCK_MERCHANT_REPOSITORY
    )

    assert_equal 5, merchant.id
    assert_equal 'Turing School', merchant.name
    assert_equal Time.parse('2010-12-10'), merchant.created_at
  end

  def test_it_can_have_different_attributes
    merchant = Merchant.new(
      {
        id: '3',
        name: 'Yale',
        created_at: '2006-03-20'
      },
      MOCK_MERCHANT_REPOSITORY
    )

    assert_equal 3, merchant.id
    assert_equal 'Yale', merchant.name
    assert_equal Time.parse('2006-03-20'), merchant.created_at
  end

  def test_can_find_all_items
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 7
    merchant2 = MOCK_SALES_ENGINE.merchants.find_by_id 9
    assert_equal 2, merchant.items.length
    assert_equal 0, merchant2.items.length
  end

  def test_can_find_invoices
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 7
    invoices = merchant.invoices

    assert_instance_of Array, invoices
    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal 7, invoice.merchant_id
    end
  end

  def test_can_get_customers
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 4
    customers = merchant.customers

    assert_instance_of Array, customers
    assert_equal 3, customers.length

    customers.each do |customer|
      assert_instance_of Customer, customer
    end
  end

  def test_can_get_total_revenue
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 2

    assert_equal BigDecimal(1_233_491) / 100.0, merchant.revenue
  end

  def test_can_check_for_pending_invoices
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 2
    assert_equal true, merchant.pending_invoices?

    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 3
    assert_equal false, merchant.pending_invoices?
  end

  def test_can_get_items_by_revenue
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 2
    items = merchant.revenue_by_item

    assert_instance_of Array, items
    assert_equal 6, items.length

    sorted = items.sort_by do |item|
      -item[:revenue]
    end

    assert_equal BigDecimal(407_487) / 100.0, sorted.first[:revenue]
  end

  def test_invoices_paid_in_full
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 2
    invoices = merchant.invoices_paid_in_full

    assert_instance_of Array, invoices
    assert_equal 2, invoices.first.id
    assert_equal 3, invoices.last.id
  end
end

# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant'
require_relative '../lib/invoice'
require_relative 'mocks/test_engine'

class MerchantTest < Minitest::Test
  def test_it_exists
    merchant = Merchant.new({ id: '5', name: 'Turing School' },
                            MOCK_MERCHANT_REPOSITORY)

    assert_instance_of Merchant, merchant
  end

  def test_it_has_attributes
    merchant = Merchant.new({ id: '5', name: 'Turing School' },
                            MOCK_MERCHANT_REPOSITORY)

    assert_equal 5, merchant.id
    assert_equal 'Turing School', merchant.name
  end

  def test_it_can_have_different_attributes
    merchant = Merchant.new({ id: '3', name: 'Yale' }, MOCK_MERCHANT_REPOSITORY)

    assert_equal 3, merchant.id
    assert_equal 'Yale', merchant.name
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

  def test_can_get_items_by_revenue
    merchant = MOCK_SALES_ENGINE.merchants.find_by_id 2
    items = merchant.revenue_by_item

    assert_instance_of Array, items
    assert_equal 6, items.length

    sorted = items.sort_by do |item|
      -item[:revenue]
    end

    assert_equal BigDecimal(563_432) / 100.0, sorted.first[:revenue]
  end
end

require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require_relative 'mocks/test_engine'

class SalesAnalystTest < Minitest::Test
  def setup
    @sa = SalesAnalyst.new MOCK_SALES_ENGINE
  end

  def test_does_create_sales_analyst
    assert_instance_of SalesAnalyst, @sa
  end

  def test_does_have_sales_engine
    assert_instance_of SalesEngine, @sa.sales_engine
  end

  def test_can_calculate_average_item_cost
    assert_equal Rational(95.0 / 4.0), @sa.average_item_cost
  end

  def test_can_calculate_item_cost_standard_deviation
    assert_equal Math.sqrt(Rational(79.0 / 14.0)) * 5,
                 @sa.item_cost_standard_deviation
  end

  def test_can_find_golden_items
    items = @sa.golden_items
    assert_instance_of Array, items
    assert_equal 1, items.length
    assert_equal 'Item E', items.first.name
  end

  def test_does_get_merchants_with_high_item_count
    merchants = @sa.merchants_with_high_item_count

    assert_instance_of Array, merchants
    assert_equal 2, merchants.length
    merchants.each do |merchant|
      assert_instance_of Merchant, merchant
    end
    assert_equal 3, merchants.first.id
    assert_equal 7, merchants[1].id
  end

  def test_does_get_average_item_merchant_price
    assert_equal 35.0, @sa.average_item_price_for_merchant(7)
    assert_equal 0, @sa.average_item_price_for_merchant(9)
  end

  def test_can_get_average_price_for_all_merchants
    assert_equal Rational(115.0 / 9.0).to_f.round(2),
                 @sa.average_average_price_per_merchant
  end

  def test_can_get_average_items_for_merchant
    assert_equal (8 / 9.0).round(2),
                 @sa.average_items_per_merchant
  end

  def test_it_can_standard_deviate_average_items_per_merchant
    assert_equal (Math.sqrt(10) / 3).round(2),
                 @sa.average_items_per_merchant_standard_deviation
  end

  def test_it_can_get_top_merchants_by_invoice_count
    merchants = @sa.top_merchants_by_invoice_count
    assert_instance_of Array, merchants
    assert_equal 1, merchants.length
    assert_equal 4, merchants.first.id
  end

  def test_it_can_get_bottom_merchants_by_invoice_count
    merchants = @sa.bottom_merchants_by_invoice_count
    assert_instance_of Array, merchants
    assert_equal 1, merchants.length
    assert_equal 9, merchants.first.id
  end

  def test_it_can_get_percentage_of_status
    assert_equal ((10.0 / 18.0) * 100).round(2), @sa.invoice_status(:pending)
    assert_equal ((6.0 / 18.0) * 100).round(2), @sa.invoice_status(:shipped)
    assert_equal ((2.0 / 18.0) * 100).round(2), @sa.invoice_status(:returned)
  end

  def test_it_can_get_average_invoices_per_merchant
    assert_equal 2.0, @sa.average_invoices_per_merchant
  end

  def test_it_can_standard_deviate_average_invoices_per_merchant
    assert_equal 1.0,
                 @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_it_can_get_busiest_days
    assert_equal ['Friday'], @sa.top_days_by_invoice_count
  end

  def test_it_can_get_total_revenue_by_date
    date = Time.parse '2012-11-23'

    expected = @sa.total_revenue_by_date(date)

    assert_instance_of BigDecimal, expected
    assert_equal BigDecimal.new(1_233_491) / 100.0, expected
  end

  def test_it_can_get_top_revenue_earners
    earners = @sa.top_revenue_earners 3
    assert_instance_of Array, earners
    assert_equal 3, earners.length

    earners.each do |earner|
      assert_instance_of Merchant, earner
    end
    assert_equal 2, earners.first.id

    earners = @sa.top_revenue_earners

    assert_instance_of Array, earners
    assert_equal 9, earners.length
  end

  def test_can_find_merchants_with_pending_invoices
    merchants = @sa.merchants_with_pending_invoices

    assert_instance_of Array, merchants
    assert_equal 2, merchants.length
    assert_instance_of Merchant, merchants[0]
    assert_equal 'Candisart', merchants[0].name
  end

  def test_can_find_merchants_with_only_one_item
    merchants = @sa.merchants_with_only_one_item

    assert_instance_of Array, merchants
    assert_instance_of Merchant, merchants[0]
    assert_equal 3, merchants.length
    assert_equal 'Candisart', merchants[1].name
  end

  def test_can_get_revenue_by_merchant
    revenue = @sa.revenue_by_merchant 2

    assert_equal BigDecimal(1_233_491) / 100.0, revenue
  end

  def test_can_get_merchants_best_item
    item = @sa.best_item_for_merchant 2

    assert_instance_of Item, item
    assert_equal 1, item.id
  end

  def test_can_rank_merchants_by_revenue
    merchants = @sa.merchants_ranked_by_revenue

    assert_instance_of Array, merchants
    assert_equal 9, merchants.length

    merchants.each do |merchant|
      assert_instance_of Merchant, merchant
    end

    assert_equal 2, merchants.first.id
    assert_equal 9, merchants.last.id
  end
end

# Defines Analytics related to Merchants
module MerchantAnalytics
  def average_invoices_per_merchant
    merchants_invoices = @sales_engine.merchants.all.map do |merchants|
      merchants.invoices.length
    end
    (merchants_invoices.reduce(:+) / merchants_invoices.length.to_f). round 2
  end

  def average_invoices_per_merchant_standard_deviation
    merchants_invoices = @sales_engine.merchants.all.map do |merchant|
      merchant.invoices.length
    end
    (StandardDeviation.calculate merchants_invoices).round 2
  end

  def top_revenue_earners(limit = 20)
    sorted_merchants = merchants_revenue.sort_by do |merchant|
      -merchant[:revenue]
    end

    sorted_merchants[0...limit].map do |merchant|
      @sales_engine.merchants.find_by_id merchant[:id]
    end
  end

  def merchants_revenue
    @sales_engine.merchants.all.map do |merchant|
      {
        id: merchant.id,
        revenue: merchant.revenue
      }
    end
  end

  def merchants_with_pending_invoices
    @sales_engine.merchants.all.reject(&:pending_invoices?)
  end

  def merchants_with_only_one_item
    merch_ids = @sales_engine.items.all.map(&:merchant_id)
    selected_ids = merch_ids.select do |id|
      merch_ids.count(id) == 1
    end
    selected_ids.map do |id|
      @sales_engine.merchants.find_by_id id
    end
  end

  def revenue_by_merchant(id)
    @sales_engine.merchants.find_by_id(id).revenue
  end

  def best_item_for_merchant(id)
    items = @sales_engine.merchants.find_by_id(id).revenue_by_item

    top_item = items.sort_by do |item|
      -item[:revenue]
    end.first

    @sales_engine.items.find_by_id top_item[:id]
  end

  def merchants_ranked_by_revenue
    merchants = @sales_engine.merchants.all

    merchants.sort_by do |merchant|
      -merchant.revenue
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    date = Time.parse month
    merchants_with_only_one_item.select do |merchant|
      merchant.created_at.month == date.month
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant = @sales_engine.merchants.find_by_id merchant_id
    invoices = merchant.invoices_paid_in_full

    invoice_items = invoices.map(&:itemize).flatten

    sorted = invoice_items.sort_by(&:quantity).reverse
    highest = highest_quantity sorted
    get_invoice_items highest
  end
end

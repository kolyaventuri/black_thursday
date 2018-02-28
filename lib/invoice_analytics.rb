module InvoiceAnalytics
  def bottom_merchants_by_invoice_count
    invoice_count = invoice_count_by_merchant
    count = invoice_count.map do |merchant|
      merchant[:invoices]
    end

    avg = count.reduce(:+) / count.length.to_f
    deviation = StandardDeviation.calculate count

    ids = merchant_ids_with_low_invoice_count invoice_count, avg, deviation
    ids.map do |id|
      @sales_engine.merchants.find_by_id id
    end
  end

  def merchant_ids_with_high_invoice_count(merchants, avg, deviation)
    list = merchants.select do |merchant|
      merchant[:invoices] >= avg + (2 * deviation)
    end

    list.map do |merchant|
      merchant[:id]
    end
  end

  def merchant_ids_with_low_invoice_count(merchants, avg, deviation)
    list = merchants.select do |merchant|
      merchant[:invoices] <= avg - (2 * deviation)
    end

    list.map do |merchant|
      merchant[:id]
    end
  end

  def invoice_count_by_merchant
    @sales_engine.merchants.all.map do |merchant|
      { id: merchant.id, invoices: merchant.invoices.length }
    end
  end

  def invoice_status(status)
    count = invoice_status_count
    total = count.values.reduce(:+)
    percentage = count[status] / total.to_f
    (percentage * 100).round 2
  end

  def invoice_status_count
    invoices = @sales_engine.invoices.all
    grouped = invoices.group_by(&:status)
    grouped.reduce({}) do |result, (in_status, list)|
      result.update in_status => list.length
    end
  end

  def top_days_by_invoice_count
    count = count_days invoice_days
    days_array = invoices_by_day count

    avg = days_array.reduce(:+) / days_array.length.to_f
    deviation = StandardDeviation.calculate days_array

    count.select do |_day, num_invoices|
      num_invoices >= avg + deviation
    end.keys
  end

  def invoice_days
    @sales_engine.invoices.all.map do |invoice|
      invoice.created_at.strftime '%A'
    end
  end

  def count_days(days)
    grouped = days.group_by { |day| day }
    day_hash = {}
    grouped.each do |day, array|
      day_hash[day] = array.length
    end

    day_hash
  end

  def invoices_by_day(days)
    day_values = days.values
    day_values.concat Array.new(7 - day_values.length, 0)
  end

  def total_revenue_by_date(date)
    invoices = @sales_engine.invoices.all.select do |invoice|
      invoice.created_at == date
    end
    return 0 if invoices.empty?

    invoices.map(&:total).reduce(:+)
  end

  def highest_quantity(invoice_items)
    invoice_items.select do |invoice_item|
      invoice_item.quantity == invoice_items.first.quantity
    end
  end

  def get_invoice_items(invoice_items)
    invoice_items.map do |invoice_item|
      @sales_engine.items.find_by_id invoice_item.item_id
    end
  end
end

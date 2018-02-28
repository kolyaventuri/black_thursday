# frozen_string_literal: true

# Defines methods for analytics regarding customer items
module CustomerItems
  def itemize_invoices(invoices)
    invoices.map(&:itemize).flatten
  end

  def one_time_buyers_top_items
    invoices = buyer_invoices_paid_in_full one_time_buyers
    invoice_items = itemize_invoices invoices
    grouped = invoice_items.group_by(&:item_id)

    totals = invoice_item_quantity_totals grouped

    max = totals.max_by { |_id, quantity| quantity }

    [@sales_engine.items.find_by_id(max[0])]
  end

  def invoice_item_quantity_totals(grouped)
    grouped.map do |item_id, invoice_items|
      [item_id, invoice_items.reduce(0) { |sum, item| sum + item.quantity }]
    end.to_h
  end

  def items_bought_in_year(customer_id, year)
    date = Time.parse("#{year}-01-01")
    invoices = @sales_engine.invoices.find_all_by_customer_id customer_id
    invoices_in_year(invoices, date).map do |invoice|
      @sales_engine.invoices.find_items_by_invoice_id invoice.id
    end.flatten
  end

  def invoices_in_year(invoices, date)
    invoices.select do |invoice|
      invoice.created_at.year == date.year
    end
  end

  def highest_volume_items(id)
    customer = @sales_engine.customers.find_by_id id

    invoices = invoices_by_item_id customer.invoices

    quantities = invoice_item_quantity_totals invoices

    max = get_highest_value(quantities)

    max_items = get_max_item(quantities, max)

    item_ids_to_items max_items
  end

  def invoices_by_item_id(invoices)
    invoice_items = itemize_invoices invoices.flatten
    invoice_items.group_by(&:item_id)
  end

  def item_ids_to_items(ids)
    ids.map do |item_id, _quantity|
      @sales_engine.items.find_by_id item_id
    end
  end

  def get_highest_value(quantities)
    quantities.max_by { |_id, value| value }.last
  end

  def get_max_item(quantities, highest_value)
    quantities.select do |_id, quantity|
      quantity == highest_value
    end
  end
end

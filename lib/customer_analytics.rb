module CustomerAnalytics
  def top_merchant_for_customer(id)
    invoices = @sales_engine.invoices.find_all_by_customer_id id

    invoice_items = invoices.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id invoice.id
    end

    grouped = invoices.group_by(&:merchant_id)

    grouped = grouped.map do |merchant_id, grouped_invoices|
      quantity = grouped_invoices.map do |invoice|
        @sales_engine.invoice_items.find_by_id(invoice.id).quantity
      end.reduce(:+)
      [merchant_id, quantity]
    end.to_h

    max = grouped.max_by do |_merch_id, quantity|
      quantity
    end

    @sales_engine.merchants.find_by_id max[0]
  end
end

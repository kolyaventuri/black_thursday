module CustomerAnalytics
  def top_merchant_for_customer(id)
    invoices = @sales_engine.invoices.find_all_by_customer_id id

    grouped = invoices.group_by(&:merchant_id)

    merchants = grouped.map do |merch_id, invoices|
      quantity = invoices.map do |invoice|
        invoice.itemize
      end.flatten.map(&:quantity).reduce(:+)

      [merch_id, quantity || 0]
    end.to_h

    max = merchants.max_by do |id, quantity|
      quantity
    end

    @sales_engine.merchants.find_by_id max[0]
  end
end

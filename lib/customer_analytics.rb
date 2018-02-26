# frozen_string_literal: true

# Defines methods for CustomerAnalytics
module CustomerAnalytics
  def top_merchant_for_customer(id)
    invoices = @sales_engine.invoices.find_all_by_customer_id id

    grouped_by_merchant = invoices.group_by(&:merchant_id)

    merchants = grouped_by_merchant.map do |merch_id, invoice_list|
      quantity = get_quantity_of_invoices invoice_list
      [merch_id, quantity || 0]
    end.to_h

    @sales_engine.merchants.find_by_id highest_quantity_merchant(merchants)[0]
  end

  def get_quantity_of_invoices(invoices)
    quantities = invoices.map(&:itemize).flatten.map(&:quantity)

    quantities.reduce(:+)
  end

  def highest_quantity_merchant(merchants)
    merchants.max_by do |_id, quantity|
      quantity
    end
  end
end

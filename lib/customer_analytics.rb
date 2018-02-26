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

  def one_time_buyers
    invoices = @sales_engine.invoices.all.group_by(&:customer_id)
    customers = customers_with_one_transaciton invoices

    solos = single_transaction_customer_ids customers

    solos.map do |customer_id|
      @sales_engine.customers.find_by_id customer_id
    end
  end

  def single_transaction_customer_ids(customers)
    customers.select do |transaction|
      transaction[1] == true
    end.to_h.keys
  end

  def customers_with_one_transaciton(customers)
    customers.map do |customer_id, invoices|
      [customer_id, invoice_paid_in_full(invoices).length == 1]
    end
  end

  def invoice_paid_in_full(invoices)
    invoices.select(&:is_paid_in_full?)
  end

  def customers_expenditure
    @sales_engine.customers.all.map do |customer|
      {
        id: customer.id,
        expenditure: customer.expenditure
      }
    end
  end

  def top_buyers(limit = 20)
    sorted_customers = customers_expenditure.sort_by do |customer|
      -customer[:expenditure]
    end

    sorted_customers[0...limit].map do |customer|
      @sales_engine.customers.find_by_id customer[:id]
    end
  end

  def items_bought_in_year(customer_id, year)
    date = Time.parse(year + '-01-01')
    invoices = @sales_engine.invoices.find_all_by_customer_id customer_id
    selected = invoices.select do |invoice|
      invoice.created_at.year.to_i == date.year
    end
    selected.map do |invoice|
      @sales_engine.invoices.find_items_by_invoice_id invoice.id
    end.flatten
  end
end

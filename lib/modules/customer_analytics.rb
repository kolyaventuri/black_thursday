# frozen_string_literal: true

require_relative 'customer_item_analytics'

# Defines methods for CustomerAnalytics
module CustomerAnalytics
  include CustomerItems

  def top_merchant_for_customer(id)
    invoices = @sales_engine.invoices.find_all_by_customer_id id

    merchants = merchant_quantities invoices.group_by(&:merchant_id)

    @sales_engine.merchants.find_by_id highest_quantity_merchant(merchants)[0]
  end

  def merchant_quantities(merchants)
    merchants.map do |merch_id, invoice_list|
      quantity = get_quantity_of_invoices invoice_list
      [merch_id, quantity || 0]
    end.to_h
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

  def buyer_invoices_paid_in_full(buyers)
    buyers.map do |buyer|
      @sales_engine.invoices.find_all_by_customer_id buyer.id
    end.flatten.select(&:is_paid_in_full?)
  end

  def customers_with_unpaid_invoices
    @sales_engine.customers.all.reject do |customer|
      customer.unpaid_invoices.empty?
    end
  end

  def best_invoice_by_revenue
    best_invoices = @sales_engine.invoices.all.sort_by do |invoice|
      -invoice.total
    end
    best_invoices.first
  end

  def best_invoice_by_quantity
    best_invoices = @sales_engine.invoices.all.sort_by do |invoice|
      [-invoice.quantify_items, invoice.id]
    end
    best_invoices.first
  end
end

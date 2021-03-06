# frozen_string_literal: true

require_relative 'customer'

# Defines the CustomerRepository, which contains Customers
class CustomerRepository
  def initialize(filename, sales_engine)
    @customers = []
    @sales_engine = sales_engine
    load_from_csv filename
  end

  def load_from_csv(filename)
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |info|
      customer = Customer.new info, self
      @customers.push customer
    end
  end

  def all
    @customers
  end

  def find_by_id(id)
    @customers.find do |customer|
      customer.id == id
    end
  end

  def find_all_by_first_name(name)
    name = name.downcase
    @customers.select do |customer|
      customer.first_name.downcase.include? name
    end
  end

  def find_all_by_last_name(name)
    name = name.downcase
    @customers.select do |customer|
      customer.last_name.downcase.include? name
    end
  end

  def merchants(id)
    @sales_engine.invoices.find_all_by_customer_id(id).map do |invoice|
      @sales_engine.merchants.find_by_id invoice.merchant_id
    end
  end

  def inspect
    "#<#{self.class} #{@customers.length} rows>"
  end

  def invoices(id)
    @sales_engine.invoices.find_all_by_customer_id id
  end

  def expenditure(id)
    invoices(id).map(&:total).reduce(:+) || 0
  end
end

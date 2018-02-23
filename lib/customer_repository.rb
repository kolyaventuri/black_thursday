# frozen_string_literal: true

require_relative 'customer'

# Defines the CustomerRepository, which contains Customers
class CustomerRepository
  def initialize(sales_engine)
    @customers = []
    @sales_engine = sales_engine
  end

  def from_csv(filename)
    CSV.foreach(
      filename,
      headers: true,
      header_converters: :symbol
    ) do |customer_info|
      customer = Customer.new customer_info, self
      @customers.push customer
    end
  end
end

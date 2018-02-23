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
end

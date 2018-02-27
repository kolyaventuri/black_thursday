# frozen_string_literal: true

# Defines a customer
class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(data, customer_repository)
    @id = data[:id].to_i
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
    @customer_repository = customer_repository
  end

  def merchants
    @customer_repository.merchants @id
  end

  def expenditure
    @customer_repository.expenditure @id
  end

  def fully_paid_invoices
    invoices.select(&:is_paid_in_full?)
  end

  def unpaid_invoices
    invoices.reject(&:is_paid_in_full?)
  end

  def invoices
    @customer_repository.invoices @i
  end
end

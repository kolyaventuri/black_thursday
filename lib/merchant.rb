# frozen_string_literal: true

# Merchant class has id and name attributes
class Merchant
  attr_reader :id,
              :name,
              :merchant_repository

  def initialize(data, merchant_repository)
    @id = data[:id].to_i
    @name = data[:name]
    @merchant_repository = merchant_repository
  end

  def items
    @merchant_repository.items @id
  end

  def invoices
    @merchant_repository.invoices @id
  end

  def customers
    @merchant_repository.customers @id
  end

  def revenue
    @merchant_repository.revenue @id
  end

  def pending_invoices?
    invoices.reject(&:is_paid_in_full?).empty?
  end
end

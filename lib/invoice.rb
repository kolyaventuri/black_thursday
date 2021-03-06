# frozen_string_literal: true

# Defines an Invoice
class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(data, repository)
    @id = data[:id].to_i
    @customer_id = data[:customer_id].to_i
    @merchant_id = data[:merchant_id].to_i

    @status = data[:status].to_sym
    @invoice_repository = repository

    parse_dates data
  end

  def parse_dates(data)
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
  end

  def merchant
    @invoice_repository.merchant @merchant_id
  end

  def items
    @invoice_repository.find_items_by_invoice_id @id
  end

  def customer
    @invoice_repository.find_customer_by_id @customer_id
  end

  def transactions
    @invoice_repository.transactions @id
  end

  def itemize
    @invoice_repository.invoice_items @id
  end

  def invoice_items
    @invoice_repository.invoice_items @id
  end

  # rubocop:disable PredicateName
  def is_paid_in_full?
    return false if transactions.empty?
    success = transactions.select do |transaction|
      transaction.result == 'success'
    end
    return false if success.empty?
    true
  end
  # rubocop:enable PredicateName

  def total
    return BigDecimal.new(0) unless is_paid_in_full?
    items = @invoice_repository.invoice_items @id
    total_sum = items.map do |item|
      item.unit_price * item.quantity
    end.reduce(:+)
    total_sum || BigDecimal.new(0)
  end

  def quantify_items
    return BigDecimal.new(0) unless is_paid_in_full?
    items = invoice_items
    quantity = items.map(&:quantity).reduce(:+)
    quantity || BigDecimal.new(0)
  end
end

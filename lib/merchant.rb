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

  def revenue_by_item
    itemized = invoices.select(&:is_paid_in_full?).map(&:itemize).flatten
    revenues = itemized.map do |invoice_item|
      {
        item_id: invoice_item.item_id,
        revenue: invoice_item.quantity * invoice_item.unit_price
      }
    end

    grouped = revenues.group_by do |revenue|
      revenue[:item_id]
    end

    grouped.map do |id, item_revenues|
      total = item_revenues.reduce(0) do |sum, revenue|
        sum + revenue[:revenue]
      end
      {
        id: id,
        revenue: total
      }
    end

  end

  def sum_item_revenue(revenues)
    summed = revenues.inject do |a, b|
      a.merge b do |_, rev_a, rev_b|
        rev_a + rev_b
      end
    end
    summed[:total]
  end
end

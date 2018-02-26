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

  def revenue_by_item
    itemized = invoices.select(&:is_paid_in_full?).map(&:itemize).flatten
    per_item = per_item_revenues(itemized)
    grouped_revenues = group_items per_item

    sum_item_revenue grouped_revenues
  end

  def per_item_revenues(itemized)
    itemized.map do |invoice_item|
      {
        item_id: invoice_item.item_id,
        revenue: invoice_item.quantity * invoice_item.unit_price
      }
    end
  end

  def group_items(revenues)
    revenues.group_by do |revenue|
      revenue[:item_id]
    end
  end

  def sum_item_revenue(revenues)
    revenues.map do |id, item_revenues|
      total = item_revenues.reduce(0) do |sum, revenue|
        sum + revenue[:revenue]
      end
      {
        id: id,
        revenue: total
      }
    end
  end
end

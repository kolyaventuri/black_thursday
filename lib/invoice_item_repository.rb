# frozen_string_literal: true

require_relative 'invoice_item'

# Defines an InvoiceItemRepository which holds InvoiceItems
class InvoiceItemRepository
  def initialize(sales_engine)
    @invoice_items = []
    @sales_engine = sales_engine
  end

  def from_csv(filename)
    CSV.foreach(
      filename,
      headers: true,
      header_converters: :symbol
    ) do |data|
      @invoice_items << InvoiceItem.new(data, self)
    end
  end

  def all
    @invoice_items
  end

  def find_by_id(id)
    @invoice_items.find do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_all_by_item_id(item_id)
    @invoice_items.select do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.select do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end
end

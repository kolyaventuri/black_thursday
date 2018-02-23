# frozen_string_literal: true

require_relative 'invoice_item'

# Defines an InvoiceItemRepository which holds InvoiceItems
class InvoiceItemRepository
  def initialize(filename, sales_engine)
    @invoice_items = []
    @sales_engine = sales_engine
    load_invoice_items filename
  end

  def load_invoice_items(filename)
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
end

# frozen_string_literal: true

require 'csv'
require_relative 'invoice'

# Defines Invoice Repository
class InvoiceRepository
  attr_reader :invoices

  def initialize(filename, sales_engine)
    @invoices = []
    @sales_engine = sales_engine
    load_invoices filename
  end

  def load_invoices(filename)
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |data|
      @invoices << Invoice.new(data, self)
    end
  end

  def all
    @invoices
  end

  def find_by_id(id)
    @invoices.find do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(id)
    @invoices.select do |invoice|
      invoice.customer_id == id
    end
  end

  def find_all_by_merchant_id(id)
    @invoices.select do |invoice|
      invoice.merchant_id == id
    end
  end

  def find_all_by_status(status)
    @invoices.select do |invoice|
      invoice.status == status
    end
  end

  def merchant(id)
    @sales_engine.merchants.find_by_id id
  end

  def inspect
    "#<#{self.class} #{@invoices.length} rows>"
  end

  def find_items_by_invoice_id(id)
    invoice_items(id).map do |invoice_item|
      @sales_engine.items.find_by_id invoice_item.item_id
    end
  end

  def find_customer_by_id(id)
    @sales_engine.customers.find_by_id id
  end

  def invoice_items(id)
    @sales_engine.invoice_items.find_all_by_invoice_id id
  end

  def transactions(id)
    @sales_engine.transactions.find_all_by_invoice_id id
  end
end

# frozen_string_literal: true

require 'CSV'
require 'pry'
require_relative 'transaction'

# Merchant Repository gets data from CSV
class TransactionRepository
  attr_reader :sales_engine

  def initialize(filepath, sales_engine)
    @transactions = []
    @sales_engine = sales_engine
    load_transactions(filepath)
  end

  def all
    @transactions
  end

  def load_transactions(filepath)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |data|
      @transactions << Transaction.new(data, self)
    end
  end

  def find_by_id(id)
    @transactions.select do |transaction|
      id == transaction.id
    end.first
  end

  def find_all_by_invoice_id(id)
    @transactions.select do |transaction|
      transaction.invoice_id == id
    end
  end

  def find_all_by_credit_card_number(num)
    num = num.to_i
    @transactions.select do |transaction|
      transaction.credit_card_number == num
    end
  end

  def find_all_by_result(status)
    @transactions.select do |transaction|
      transaction.result == status
    end
  end

  def inspect
    "#<#{self.class} #{@transactions.length} rows>"
  end

  def find_invoice_by_transaction_id(id)
    transaction = find_by_id id
    @sales_engine.invoices.find_by_id transaction.invoice_id
  end
end

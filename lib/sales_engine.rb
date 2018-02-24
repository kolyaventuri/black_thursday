# frozen_string_literal: true

require 'bigdecimal'

require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require_relative 'invoice_item_repository'

# Defines sales engine
class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :transactions,
              :invoice_items,
              :customers

  def initialize(files)
    @items = ItemRepository.new files[:items], self
    @merchants = MerchantRepository.new files[:merchants], self
    @invoices = InvoiceRepository.new files[:invoices], self
    @transactions = TransactionRepository.new files[:transactions], self
    @invoice_items = InvoiceItemRepository.new self
    @customers = CustomerRepository.new self

    @invoice_items.from_csv files[:invoice_items]
    @customers.from_csv files[:customers]
  end

  def self.from_csv(files)
    new files
  end
end

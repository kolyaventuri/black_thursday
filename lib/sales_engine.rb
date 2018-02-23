# frozen_string_literal: true

require 'bigdecimal'

require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'

# Defines sales engine
class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items

  def initialize(files)
    @items = ItemRepository.new files[:items], self
    @merchants = MerchantRepository.new files[:merchants], self
    @invoices = InvoiceRepository.new files[:invoices], self
    @invoice_items = InvoiceItemRepository.new files[:invoice_items], self
  end

  def self.from_csv(files)
    new files
  end
end

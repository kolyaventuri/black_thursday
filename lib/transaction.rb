# frozen_string_literal: true

require 'time'

# Defines a transaction
class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :transaction_repository

  def initialize(data, transaction_repository)
    ids data
    parse_dates data
    @credit_card_number = data[:credit_card_number].to_i
    @credit_card_expiration_date = data[:credit_card_expiration_date]
    @result = data[:result]
    @transaction_repository = transaction_repository
  end

  def ids(data)
    @id = data[:id].to_i
    @invoice_id = data[:invoice_id].to_i
  end

  def parse_dates(data)
    @created_at = Time.parse data[:created_at]
    @updated_at = Time.parse data[:updated_at]
  end

  def invoice
    @transaction_repository.find_invoice_by_transaction_id @id
  end
end

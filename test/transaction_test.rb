# frozen_string_literal: true

require_relative 'test_helper'

require_relative '../lib/transaction.rb'
require_relative 'mocks/test_engine'

class TransactionTest < Minitest::Test
  TIME = Time.parse '2016-01-11 17:42:32 UTC'
  def setup
    @transaction = Transaction.new(
      { id: 20,
        invoice_id: 12,
        credit_card_number: '4318767847968505',
        credit_card_expiration_date: '0218',
        result: 'success',
        created_at: '2012-02-26 20:56:57 UTC',
        updated_at: '2012-02-26 20:56:57 UTC' },
      MOCK_TRANSACTION_REPOSITORY
    )
  end

  def test_creates_transaction
    assert_instance_of Transaction, @transaction
  end

  def test_stores_transaction_id_and_credit_card
    assert_equal 20, @transaction.id
    assert_equal 12, @transaction.invoice_id
    assert_equal '4318767847968505'.to_i, @transaction.credit_card_number
    assert_equal '0218', @transaction.credit_card_expiration_date
  end

  def test_stores_transaction_time_and_payment_result
    assert_equal 'success', @transaction.result
    assert_equal Time.parse('2012-02-26 20:56:57 UTC'), @transaction.created_at
    assert_equal Time.parse('2012-02-26 20:56:57 UTC'), @transaction.updated_at
  end

  def test_can_get_invoice
    invoice = @transaction.invoice
    assert_instance_of Invoice, invoice
    assert_equal 12, invoice.id
    assert_equal 2, invoice.customer_id
    assert_equal :returned, invoice.status
  end
end

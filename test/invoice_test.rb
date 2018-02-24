# frozen_string_literal: true

require 'time'
require_relative 'test_helper.rb'

require './lib/invoice.rb'
require './lib/invoice_repository'
require './test/mocks/test_engine'

class InvoiceTest < Minitest::Test
  TIME = Time.parse '2016-01-11 17:42:32 UTC'
  def setup
    invoice_data = {
      id: 3,
      customer_id: 7,
      merchant_id: 8,
      status: 'pending',
      created_at: '2016-01-11 17:42:32 UTC',
      updated_at: '2016-01-11 17:42:32 UTC'
    }
    @invoice = Invoice.new(invoice_data, MOCK_INVOICE_REPOSITORY)
  end

  def test_does_create_invoice
    assert_instance_of Invoice, @invoice
  end

  def test_attributes
    assert_equal 3, @invoice.id
    assert_equal 7, @invoice.customer_id
    assert_equal 8, @invoice.merchant_id
    assert_equal :pending, @invoice.status
    assert_equal TIME, @invoice.created_at
    assert_equal TIME, @invoice.updated_at
  end

  def test_can_get_merchant
    assert_equal 8, @invoice.merchant.id
  end

  def test_can_find_items
    items = @invoice.items
    assert_instance_of Array, items
    assert_equal 3, items.length
    items.each do |item|
      assert_instance_of Item, item
    end
  end

  def test_can_get_customer
    customer = @invoice.customer
    assert_instance_of Customer, customer
    assert_equal 7, customer.id
    assert_equal 'Parker', customer.first_name
  end

  def test_can_get_total_amount
    assert_equal 7045.78, @invoice.total
  end
end

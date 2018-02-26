# frozen_string_literal: true

require_relative 'test_helper.rb'

require './lib/customer.rb'
require './test/mocks/test_engine'

class CustomerTest < Minitest::Test
  TIME = Time.parse '2012-03-27 14:54:09 UTC'

  def setup
    @customer = Customer.new(
      {
        id: 6,
        first_name: 'Joan',
        last_name: 'Clarke',
        created_at: '2012-03-27 14:54:09 UTC',
        updated_at: '2012-03-27 14:54:09 UTC'
      },
      MOCK_CUSTOMER_REPOSITORY
    )
  end

  def test_it_creates_customer
    assert_instance_of Customer, @customer
  end

  def test_attributes
    assert_equal 6, @customer.id
    assert_equal 'Joan', @customer.first_name
    assert_equal 'Clarke', @customer.last_name
    assert_equal TIME, @customer.created_at
    assert_equal TIME, @customer.updated_at
  end

  def test_it_can_get_list_of_merchants
    merchants = @customer.merchants

    assert_instance_of Array, merchants
    assert_equal 2, merchants.length

    merchants.each do |merchant|
      assert_instance_of Merchant, merchant
    end
  end

  def test_can_generate_customer_expenditure
    assert_equal 0.528913e4, @customer.expenditure
  end

  # rubocop:disable MethodLength
  def test_can_get_fully_paid_invoices
    customer = Customer.new(
      {
        id: 4,
        first_name: 'Joan',
        last_name: 'Clarke',
        created_at: '2012-03-27 14:54:09 UTC',
        updated_at: '2012-03-27 14:54:09 UTC'
      },
      MOCK_CUSTOMER_REPOSITORY
    )

    invoices = customer.fully_paid_invoices
    assert_instance_of Array, invoices
    assert_equal 2, invoices.length

    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
    end

    assert_equal 6, invoices.first.id
  end
  # rubocop:enable MethodLength
end

require_relative 'test_helper.rb'

require './lib/customer_repository.rb'
require './test/mocks/test_engine'

class CustomerRepositoryTest < Minitest::Test
  def setup
    @repo = CustomerRepository.new MOCK_CUSTOMER_REPOSITORY
    @repo.from_csv './test/fixtures/customers.csv'
  end

  def test_can_create_repository
    assert_instance_of CustomerRepository, @repo
  end

  def test_can_load_all_customers
    customers = @repo.all
    assert_instance_of Array, customers
    customers.each do |customer|
      assert_instance_of Customer, customer
    end
  end

  def test_it_can_find_by_id
    customer = @repo.find_by_id 6
    assert_instance_of Customer, customer
    assert_equal 6, customer.id
    assert_equal 'Heber', customer.first_name
  end

  def test_it_can_search_by_first_name
    customers = @repo.find_all_by_first_name 'Logan'

    assert_instance_of Array, customers
    assert_equal 2, customers.length
    customers.each do |customer|
      assert_instance_of Customer, customer
    end

    assert_equal 11, customers[0].id
    assert_equal 15, customers[1].id
  end
end

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
end

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
end

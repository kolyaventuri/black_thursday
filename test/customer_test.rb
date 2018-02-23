require_relative 'test_helper.rb'

require './lib/customer.rb'

class CustomerTest < Minitest::Test
  def setup
    @customer = Customer.new
  end

  def test_it_creates_customer
    assert_instance_of Customer, @customer
  end
end

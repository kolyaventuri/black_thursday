require_relative 'test_helper'

require 'bigdecimal'
require_relative '../lib/item.rb'

class ItemTest < Minitest::Test
  def test_does_create_item
    item = Item.new(
      name: 'Pencil',
      description: 'You can use it to write things',
      unit_price: BigDecimal.new(10.99, 4),
      created_at: Time.now,
      updated_at: Time.now
    )

    assert_instance_of Item, item
  end
end

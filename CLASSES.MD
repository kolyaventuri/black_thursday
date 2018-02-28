# Item

Defines an item in the database

#### Instantiation
```
i = Item.new({
  :name        => "Pencil",
  :description => "You can use it to write things",
  :unit_price  => BigDecimal.new(10.99,4),
  :created_at  => Time.now,
  :updated_at  => Time.now,
})
```

#### Attributes
* id (Integer) - Item ID
* name (String) - Item name
* description (String) - Item description
* unit_price (BigDecimal) - Item price in USD
* created_at (Date) - Date the item was created
* updated_at (Date) -
* merchant_id (Integer) - Merchant who is selling the item

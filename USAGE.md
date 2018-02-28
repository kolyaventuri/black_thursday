# SalesAnalyst Usage

SalesAnalyst exposes the following methods

## Item Related

#### #average_item_cost &#8594; Float
  Returns the average cost of all items

#### #item_cost_standard_deviation &#8594; Float
  Returns the standard deviation of all item costs

#### #golden_items &#8594; [Item]
  Returns all items for which their cost is at least 2 standard deviations above the average

## Merchant Related

#### #merchants_with_high_item_count &#8594; [Merchant]
  Returns all merchants who have an item count at least 1 standard deviation above the average.

#### #average_item_price_for_merchant(id) &#8594; Float
  Returns the average cost of items for sale by a specific merchant ID

#### #average_average_price_per_merchant &#8594; Float
  Returns the average cost of all items, across all merchants

#### #average_items_per_merchant &#8594; Float
  Returns the average number of items per merchant

#### #top_revenue_earners(limit = 20) &#8594; [Merchant]
  Returns the top 20 or limit merchants with the most revenue.

#### #merchants_with_pending_invoices &#8594; [Merchant]
  Returns all merchants with currently pending invoices.

#### #merchants_with_only_one_item &#8594; [Merchant]
  Returns all merchants with only one item in the marketplace.

#### #best_item_for_merchant(merchant_id) &#8594; Item
  Returns the top selling item by revenue for a given merchant id.

#### #merchants_ranked_by_revenue &#8594; [Merchant]
  Returns an array of merchants ranked by their revenue in descending order.

#### #merchants_with_only_one_item_registered_in_month(month) &#8594; [Merchant]
  Returns all merchants with only one item, who registered in a given month.

  Month is supplied as a string, ex. `"December"`

#### #most_sold_item_for_merchant(merchant_id) &#8594; [Item]
  Returns the best selling item(s) by quantity for a given merchant ID.
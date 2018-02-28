## Black Thursday

Analytics and data analysis for Etsy transactions.

Project at Turing School of Software and design.

Backend 1801.

[Project Spec](https://github.com/turingschool/curriculum/blob/master/source/projects/black_thursday.markdown)

### Required gems
Base functionality requires no gems. Running tests requires minitest, simplecov, and pry, which can be installed with `gem install minitest simplecov pry`

### Setup
The two classes required for usage are the SalesEngine and SalesAnalyst.

Create a sales engine by passing in paths (relative or absolute) to your data CSV files, as follows.

```
sales_engine = SalesEngine.new(
    {
      items: '[ITEMS CSV]',
      merchants: '[MERCHANTS CSV]',
      invoices: '[INVOICES CSV]',
      transactions: '[TRANSACTIONS CSV]',
      invoice_items: '[INVOICE ITEMS CSV]',
      customers: '[CUSTOMERS CSV]',
    }
)
```

The sales engine will handle loading data into repositories.

The sales analyst can be instantiated as follows, using your created sales engine

```
sales_analyst = SalesAnalyst.new(sales_engine)
```

## Usage

All usage is accomplished through SalesAnalyst.
SalesAnalyst documentation is available through [USAGE.MD](USAGE.MD)

## Testing

Basic testing can be accomplished with `rake`

A robust spec harness is available [here](https://github.com/turingschool/black_thursday_spec_harness).

# Model

The `Model` has the purpose to handle the Database operations, validations on Schema and handle of changes on the balance.
Uses the [Ecto](https://hexdocs.pm/ecto/Ecto.html), [Ecto_SQL](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html) and [Postgrex](https://hex.pm/packages/postgrex) to integrate with database

## Structure

The Directories and Modules structures is based on [Command and Query Responsibility Segregation (CQRS) pattern](https://github.com/MicrosoftDocs/architecture-center/blob/master/docs/patterns/cqrs.md), 
It has modules for each context (Accounts, Balance Events and trade):

- `_schema` module´s: Consist on Schema definition, mapping a Database Table, also contains the changeset, a set of validations and data transformation to work with the schema data
- `_queries` module´s: The `Ecto` or non `Ecto` Queries for Loader and Mutator
- `_loader` module´s: Read operations
- `_mutator` module´s: Write and Update operations

## Database Model

![alt text](assets/database.png "Title")

## Account

The account schema represents the user Account
it has a encrypted `password` powered by `Comeonin`, a unique `email`(username) and `name`

see `Banking.Model.Accounts.AccountSchema`

## Balance Event

Represents the balance of an Account, each event(balance change) generates a new `Banking.Model.Balances.EventSchema` with the `balance` and the history is registered by the `parent` field
there are four types of event´s `Deposit`, `Withdrawal`, `TransferIssued`, `TransferReceived`

- The `balance`, `quantity_moved` and `Type`

These fields are part crucial of the Banking, inside the changeset they are used to calculate the new balance and the `sign` of the quantity.
**You can't set the balance by yourself**, the balance is calculate dynamically using the `type` and `quantity_moved`

for more information see `Banking.Model.Balances.EventSchema`

## Trade

Register the transactions for an Account, the main purpose of this is to have a connection between the account that issue the operation and the account received(also know as `transfer_account` on `Banking.Model.Trades.TradeSchema`)
Each operation register an Trade, and if there's operation between two accounts, will be created two `Banking.Model.Trades.TradeSchema`

see `Banking.Model.Trades.TradeSchema`

### Main Dependencies

#### Decimal (For balances and quantities)

`Decimal` is used to represent the `quantity` and `balance`, these fields are based on [ISO_4217](https://en.wikipedia.org/wiki/ISO_4217)
created using data types DECIMAL(19,4)

#### comeonin

[Comeonin](https://hexdocs.pm/comeonin/5.1.1/Comeonin.html) is a specification for password hashing libraries and is used for `password` hash on `Banking.Model.Accounts.AccountSchema`

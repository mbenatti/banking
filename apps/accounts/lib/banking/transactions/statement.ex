defmodule Banking.Accounts.Transactions.Statement do
  @moduledoc """
  The bank statement of an account

  Responsible to retrieve the statement and get the balance of an account

  see `get/1` and `get_balance/1`
  """

  alias Banking.Model.Trades.TradeLoader
  alias Banking.Model.Balances.{EventLoader, EventSchema}

  @doc """
  Get the Bank Statement of a Bank Account

  Contain the series of trades of an account, with all operations detailed.

  A Statement refers of all transactions of an account, is returned a list of each trade with following params:
  `balance`, `type`, `quantity`, `date` and trade. see `t:Banking.Model.Trades.TradeLoader.t_statement/0`

  ## Examples

      iex> Statement.get(4)
      [
      %{
        balance: #Decimal<100.0000>,
        date: ~N[2019-04-08 08:42:17],
        quantity: #Decimal<100.0000>,
        trade: %Banking.Model.Trades.TradeSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
          account: "le@email.com",
          account_id: 4,
          balance: nil,
          balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
          balance_event_id: 38,
          id: 20,
          inserted_at: ~N[2019-04-08 08:42:17],
          quantity: nil,
          transfer_account: nil,
          transfer_account_id: nil,
          type: nil,
          updated_at: ~N[2019-04-08 08:42:17]
        },
        type: Banking.Model.Enums.BankOperationEnum.Type.Deposit
      },
      %{
        balance: #Decimal<4100.0000>,
        date: ~N[2019-04-08 08:42:25],
        quantity: #Decimal<4000.0000>,
        trade: %Banking.Model.Trades.TradeSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
          account: "le@email.com",
          account_id: 4,
          balance: nil,
          balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
          balance_event_id: 39,
          id: 21,
          inserted_at: ~N[2019-04-08 08:42:25],
          quantity: nil,
          transfer_account: nil,
          transfer_account_id: nil,
          type: nil,
          updated_at: ~N[2019-04-08 08:42:25]
        },
        type: Banking.Model.Enums.BankOperationEnum.Type.Deposit
      },
      %{
        balance: #Decimal<3000.0000>,
        date: ~N[2019-04-08 08:42:41],
        quantity: #Decimal<-1100.0000>,
        trade: %Banking.Model.Trades.TradeSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
          account: "le@email.com",
          account_id: 4,
          balance: nil,
          balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
          balance_event_id: 40,
          id: 22,
          inserted_at: ~N[2019-04-08 08:42:41],
          quantity: nil,
          transfer_account: nil,
          transfer_account_id: nil,
          type: nil,
          updated_at: ~N[2019-04-08 08:42:41]
        },
        type: Banking.Model.Enums.BankOperationEnum.Type.Withdrawal
      }
      ]

  """
  @spec get(String.t()) :: [TradeLoader.t_statement()] | []
  def get(account_id) do
    TradeLoader.get_statement(account_id)
  end

  @doc """
  Get the balance of an event

  see `t:Banking.Model.Balances.EventSchema.t/0`

  ## Examples

      iex> Statement.get_balance 5
      %{balance: #Decimal<0>}

      iex> Statement.get_balance 4
      %{balance: #Decimal<3000.0000>}

  """
  @spec get_balance(String.t()) :: Map.t()
  def get_balance(account_id) do
    case EventLoader.get_last_event_by_account(account_id) do
      nil -> %{balance: Decimal.new(0)}
      %EventSchema{balance: last_balance} -> %{balance: last_balance}
    end
  end
end

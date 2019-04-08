defmodule Banking.Model.Trades.TradeQueries do
  @moduledoc """
  The queries for the trades context for `t:Banking.Model.Trades.TradeSchema.t/0`
  """

  alias Banking.Model.Trades.TradeSchema
  alias Banking.Model.Balances.EventSchema
  alias Banking.Model.Accounts.AccountSchema

  import Ecto.Query

  @doc """
  Return a query for a select an `t:Banking.Model.Trades.TradeSchema.t/0`
  """
  @spec all() :: TradeSchema.t()
  def all, do: TradeSchema

  @doc """
  Query for the bank statement.

  ## Examples

      iex> TradeQueries.get_statement_by_account_id(1)
      #Ecto.Query<from t0 in Banking.Model.Trades.TradeSchema,
      join: e1 in Banking.Model.Balances.EventSchema,
      on: t0.balance_event_id == e1.id, where: t0.account_id == ^1,
      select: %{quantity: e1.quantity_moved, type: e1.type, date: e1.inserted_at, trade: t0},
      preload: [account: #Ecto.Query<from a0 in Banking.Model.Accounts.AccountSchema, select: a0.email>, transfer_account: #Ecto.Query<from a0 in Banking.Model.Accounts.AccountSchema, select: a0.email>]>
  """
  @spec get_statement_by_account_id(Integer.t()) :: Query.t()
  def get_statement_by_account_id(account_id) do
    trade_account_email_query =
      from(acc in AccountSchema,
        select: acc.email
      )

    from(trade in all(),
      join: b_event in EventSchema,
      on: trade.balance_event_id == b_event.id,
      select: %{
        quantity: b_event.quantity_moved,
        type: b_event.type,
        date: b_event.inserted_at,
        balance: b_event.balance,
        trade: trade
      },
      where: trade.account_id == ^account_id,
      preload: [account: ^trade_account_email_query],
      preload: [transfer_account: ^trade_account_email_query]
    )
  end

  @doc """
  Query for the report by day
  """
  @spec get_report_by_day() :: Query.t()
  def get_report_by_day() do
    from(trade in all(),
      join: b_event in EventSchema,
      on: trade.balance_event_id == b_event.id,
      select: %{
        day_date: fragment("date_trunc('day', ?) as report", b_event.inserted_at),
        deposit_amount:
          fragment(
            "SUM(CASE WHEN ? = 'DEPOSIT' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        withdrawal_amount:
          fragment(
            "SUM(CASE WHEN ? = 'WITHDRAWAL' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_issued_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_ISSUED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_received_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_RECEIVED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          )
      },
      group_by: fragment("report")
    )
  end

  @doc """
  Query for the report by month
  """
  @spec get_report_by_month() :: Query.t()
  def get_report_by_month() do
    from(trade in all(),
      join: b_event in EventSchema,
      on: trade.balance_event_id == b_event.id,
      select: %{
        month_date: fragment("date_trunc('month', ?) as report", b_event.inserted_at),
        deposit_amount:
          fragment(
            "SUM(CASE WHEN ? = 'DEPOSIT' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        withdrawal_amount:
          fragment(
            "SUM(CASE WHEN ? = 'WITHDRAWAL' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_issued_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_ISSUED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_received_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_RECEIVED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          )
      },
      group_by: fragment("report")
    )
  end

  @doc """
  Query for the report by year
  """
  @spec get_report_by_year() :: Query.t()
  def get_report_by_year() do
    from(trade in all(),
      join: b_event in EventSchema,
      on: trade.balance_event_id == b_event.id,
      select: %{
        year_date: fragment("date_trunc('year', ?) as report", b_event.inserted_at),
        deposit_amount:
          fragment(
            "SUM(CASE WHEN ? = 'DEPOSIT' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        withdrawal_amount:
          fragment(
            "SUM(CASE WHEN ? = 'WITHDRAWAL' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_issued_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_ISSUED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_received_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_RECEIVED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          )
      },
      group_by: fragment("report")
    )
  end

  @doc """
  Query for the report of total traded
  """
  @spec get_report_total() :: Query.t()
  def get_report_total() do
    from(trade in all(),
      join: b_event in EventSchema,
      on: trade.balance_event_id == b_event.id,
      select: %{
        deposit_amount:
          fragment(
            "SUM(CASE WHEN ? = 'DEPOSIT' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        withdrawal_amount:
          fragment(
            "SUM(CASE WHEN ? = 'WITHDRAWAL' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_issued_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_ISSUED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          ),
        transfer_received_amount:
          fragment(
            "SUM(CASE WHEN ? = 'TRANSFER_RECEIVED' THEN ? ELSE 0 END)",
            b_event.type,
            b_event.quantity_moved
          )
      }
    )
  end
end

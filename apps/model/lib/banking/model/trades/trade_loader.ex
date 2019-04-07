defmodule Banking.Model.Trades.TradeLoader do
  @moduledoc """
  Execute read operations on database for Trades context.
  """

  alias Banking.Model.Trades.{TradeQueries}
  alias Banking.Model.Repo
  alias __MODULE__
  alias Banking.Model.Enums.BankOperationEnum

  @type t_statement :: [
          %{
            type: BankOperationEnum.t(),
            quantity: Decimal.t(),
            date: NaiveDateTime.t(),
            trade: TradeSchema.t()
          }
        ]
  @type t_day_report :: [
          %{
            day_date: String.t(),
            deposit_amount: Decimal.t(),
            withdrawal_amount: Decimal.t(),
            transfer_issued_amount: Decimal.t(),
            transfer_received_amount: Decimal.t()
          }
        ]
  @type t_month_report :: [
          %{
            month_date: String.t(),
            deposit_amount: Decimal.t(),
            withdrawal_amount: Decimal.t(),
            transfer_issued_amount: Decimal.t(),
            transfer_received_amount: Decimal.t()
          }
        ]
  @type t_year_report :: [
          %{
            year_date: String.t(),
            deposit_amount: Decimal.t(),
            withdrawal_amount: Decimal.t(),
            transfer_issued_amount: Decimal.t(),
            transfer_received_amount: Decimal.t()
          }
        ]
  @type t_total :: %{
          deposit_amount: Decimal.t(),
          withdrawal_amount: Decimal.t(),
          transfer_issued_amount: Decimal.t(),
          transfer_received_amount: Decimal.t()
        }

  @doc """
  Get Statement of an Account, this mean, all trades for determined account

  ## Examples

      iex(22)> TradeLoader.get_statement(2)
      [
      %{
        date: ~N[2019-04-07 14:11:00],
        quantity: #Decimal<100000.0000>,
        trade: %Banking.Model.Trades.TradeSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
          account: "jose@email.com",
          account_id: 2,
          balance: nil,
          balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
          balance_event_id: 16,
          id: 5,
          inserted_at: ~N[2019-04-07 14:11:00],
          quantity: nil,
          transfer_account: nil,
          transfer_account_id: nil,
          type: nil,
          updated_at: ~N[2019-04-07 14:11:00]
        },
        type: Banking.Model.Enums.BankOperationEnum.Type.Deposit
      },
      %{
        date: ~N[2019-04-07 14:11:39],
        quantity: #Decimal<1000.0000>,
        trade: %Banking.Model.Trades.TradeSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
          account: "jose@email.com",
          account_id: 2,
          balance: nil,
          balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
          balance_event_id: 18,
          id: 7,
          inserted_at: ~N[2019-04-07 14:11:39],
          quantity: nil,
          transfer_account: "marcos@email.com",
          transfer_account_id: 1,
          type: nil,
          updated_at: ~N[2019-04-07 14:11:39]
        },
        type: Banking.Model.Enums.BankOperationEnum.Type.TransferReceived
      },
      ...
      ]

  """
  @spec get_statement(String.t()) :: [TradeLoader.t_statement()] | []
  def get_statement(account_id) do
    account_id
    |> TradeQueries.get_statement_by_account_id()
    |> Repo.all()
  end

  @doc """
  Get an report of all trades grouped by day

  iex> TradeLoader.get_report_by_day()
  [%{
    day_date: ~N[2019-04-06 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  },
  %{
    day_date: ~N[2019-04-07 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  }]
  """
  @spec get_report_by_day() :: [TradeLoader.t_day_report()] | []
  def get_report_by_day() do
    TradeQueries.get_report_by_day()
    |> Repo.all()
  end

  @doc """
  Get an report of all trades grouped by month

  iex> TradeLoader.get_report_by_month()
  [%{
    month_date: ~N[2019-04-01 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  },
  %{
    month_date: ~N[2019-03-01 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  }]
  """
  @spec get_report_by_month() :: [TradeLoader.t_month_report()] | []
  def get_report_by_month() do
    TradeQueries.get_report_by_month()
    |> Repo.all()
  end

  @doc """
  Get an report of all trades grouped by year

  iex> TradeLoader.get_report_by_year()
    [%{
    year_date: ~N[2019-01-01 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  },
  %{
    year_date: ~N[2018-01-01 00:00:00.000000],
    deposit_amount: #Decimal<240000.0000>,
    transfer_issued_amount: #Decimal<-21000.0000>,
    transfer_received_amount: #Decimal<21000.0000>,
    withdrawal_amount: #Decimal<-151000.0000>
  }]
  """
  @spec get_report_by_year() :: [TradeLoader.t_year_report()] | []
  def get_report_by_year() do
    TradeQueries.get_report_by_year()
    |> Repo.all()
  end

  @doc """
  Get total traded

  ## Examples

      iex(26)> TradeLoader.get_report_total()
      %{
      deposit_amount: #Decimal<240000.0000>,
      transfer_issued_amount: #Decimal<-21000.0000>,
      transfer_received_amount: #Decimal<21000.0000>,
      withdrawal_amount: #Decimal<-151000.0000>
      }
  """
  @spec get_report_total() :: TradeLoader.t_total()
  def get_report_total() do
    TradeQueries.get_report_total()
    |> Repo.one()
  end
end

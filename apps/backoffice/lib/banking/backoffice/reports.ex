defmodule Banking.Backoffice.Reports do
  @moduledoc """
  The 'Business Logic' for reports on backoffice

  Aggregates all Reports operations calling the respective function on `Banking.Model.Trades.TradeLoader`
  """

  alias Banking.Model.Trades.TradeLoader

  @doc """
  Daily report containing a list with maps like the example above:

      [%{
        day_date: ~N[2019-04-06 00:00:00.000000],
        deposit_amount: #Decimal<240000.0000>,
        transfer_issued_amount: #Decimal<-21000.0000>,
        transfer_received_amount: #Decimal<21000.0000>,
        withdrawal_amount: #Decimal<-151000.0000>
      }]

  see `Banking.Model.Trades.TradeLoader.get_report_by_day/0`
  see `Banking.APIWeb.BackofficeController` for more information
  """
  @spec daily() :: [TradeLoader.t_day_report()] | []
  def daily do
    TradeLoader.get_report_by_day()
  end

  @doc """
  Monthly report containing a list with maps like the example above:

      [%{
        month_date: ~N[2019-03-01 00:00:00.000000],
        deposit_amount: #Decimal<240000.0000>,
        transfer_issued_amount: #Decimal<-21000.0000>,
        transfer_received_amount: #Decimal<21000.0000>,
        withdrawal_amount: #Decimal<-151000.0000>
      }]

  see `Banking.Model.Trades.TradeLoader.get_report_by_month/0`
  see `Banking.APIWeb.BackofficeController` for more information
  """
  @spec monthly() :: [TradeLoader.t_month_report()] | []
  def monthly do
    TradeLoader.get_report_by_month()
  end

  @doc """
  Yearly report containing a list with maps like the example above:

      [%{
        year_date: ~N[2018-01-01 00:00:00.000000],
        deposit_amount: #Decimal<240000.0000>,
        transfer_issued_amount: #Decimal<-21000.0000>,
        transfer_received_amount: #Decimal<21000.0000>,
        withdrawal_amount: #Decimal<-151000.0000>
      }]

  see `Banking.Model.Trades.TradeLoader.get_report_by_month/0`
  see `Banking.APIWeb.BackofficeController` for more information
  """
  @spec yearly() :: [TradeLoader.t_year_report()] | []
  def yearly do
    TradeLoader.get_report_by_year()
  end

  @doc """
  Yearly report containing a  Map like the example above:

      %{
      deposit_amount: #Decimal<240000.0000>,
      transfer_issued_amount: #Decimal<-21000.0000>,
      transfer_received_amount: #Decimal<21000.0000>,
      withdrawal_amount: #Decimal<-151000.0000>
      }

  see `Banking.Model.Trades.TradeLoader.get_report_total/0`
  see `Banking.APIWeb.BackofficeController` for more information
  """
  @spec total() :: TradeLoader.t_total()
  def total do
    TradeLoader.get_report_total()
  end
end

defmodule Banking.Model.Trades.TradeLoaderTest do
  @moduledoc """
  Tests validating the schema changeset
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Trades.TradeLoader

  import Banking.Model.DataInsertion

  describe("report") do
    test "daily report" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-1)
      |> create_trade_with_parent(-2)

      report = TradeLoader.get_report_by_day()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :day_date)
    end

    test "monthly report" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-32)
      |> create_trade_with_parent(-62)

      report = TradeLoader.get_report_by_month()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :month_date)
    end

    test "year report" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-366)
      |> create_trade_with_parent(-732)

      report = TradeLoader.get_report_by_year()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :year_date)
    end

    test "total report" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-1000)

      report_total = TradeLoader.get_report_total()

      assert Map.has_key?(report_total, :deposit_amount)
    end
  end

  describe "get_statement/1" do
    test "success" do
      last_trade =
        create_trade()
        |> create_trade_with_parent()
        |> create_trade_with_parent()
        |> create_trade_with_parent(-2)
        |> create_trade_with_parent(-2)
        |> create_trade_with_parent(-100)

      statement = TradeLoader.get_statement(last_trade.account_id)
      sample = List.first(statement)

      assert Enum.count(statement) == 6
      refute is_nil(sample.quantity)
      refute is_nil(sample.type)
      refute is_nil(sample.trade)
      assert is_bitstring(sample.trade.account)
    end
  end
end

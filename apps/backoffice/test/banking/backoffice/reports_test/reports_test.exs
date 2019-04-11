defmodule Banking.Backoffice.ReportsTest do
  use Banking.Model.DataCase

  alias Banking.Backoffice.Reports
  import Banking.Model.DataInsertion

  describe "reports" do
    test "daily" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-1)
      |> create_trade_with_parent(-2)

      report = Reports.daily()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :day_date)
    end

    test "monthly" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-32)
      |> create_trade_with_parent(-62)

      report = Reports.monthly()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :month_date)
    end

    test "yearly" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-366)
      |> create_trade_with_parent(-732)

      report = Reports.yearly()
      sample = List.first(report)

      assert Enum.count(report) == 3
      assert Map.has_key?(sample, :year_date)
    end

    test "total" do
      create_trade()
      |> create_trade_with_parent()
      |> create_trade_with_parent(-1000)

      report_total = Reports.total()

      assert Map.has_key?(report_total, :deposit_amount)
    end
  end
end

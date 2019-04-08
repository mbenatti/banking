defmodule Banking.Transactions.StatementTest do
  @moduledoc """
  Tests for statement logic
  """
  use Banking.Model.DataCase

  import Banking.Model.Factory

  alias Banking.Accounts.Transactions.Statement

  describe "get/2" do
    test "return the statement" do
      trade = insert(:trade)
      trade2 = insert(:trade, account_id: trade.account_id, account: trade.account)

      statement = Statement.get(trade2.account_id)

      assert Enum.count(statement) == 2

      sample = List.first(statement)

      assert Map.has_key?(sample, :date)
      assert Map.has_key?(sample, :quantity)
      assert Map.has_key?(sample, :trade)
      assert Map.has_key?(sample, :type)
      assert Map.has_key?(sample, :balance)
    end
  end

  describe "get_balance/2" do
    test "return correct balance" do
      trade = insert(:trade)

      %{balance: balance} = Statement.get_balance(trade.account_id)

      assert balance == Decimal.add(trade.balance_event.balance, Decimal.new("0.0000"))
    end
  end
end

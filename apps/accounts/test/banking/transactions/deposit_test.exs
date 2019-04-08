defmodule Banking.Transaction.DepositTest do
  @moduledoc """
  Tests for deposit logic
  """
  use Banking.Model.DataCase

  import Banking.Model.Factory

  alias Banking.Accounts.Transactions.Deposit
  alias Banking.Model.Balances.{EventLoader, EventSchema}
  alias Banking.Model.Trades.{TradeSchema}
  alias Banking.Model.Repo
  alias Banking.Model.Enums.BankOperationEnum.Type

  describe "create/2" do
    test "success deposit" do
      account = insert(:account)

      deposit1 = Decimal.new("10.0000")
      deposit2 = Decimal.new("2000.0000")

      assert {:ok, _} = Deposit.create(account.id, deposit1)
      assert {:ok, _} = Deposit.create(account.id, deposit2)

      events = Repo.all(EventSchema)
      trades = Repo.all(TradeSchema)

      assert Enum.count(events) == 2
      assert Enum.count(trades) == 2

      sample = List.first(events)
      assert sample.type == Type.Deposit

      last_event = EventLoader.get_last_event_by_account(account.id)

      assert last_event.balance == Decimal.add(deposit1, deposit2)
    end
  end
end

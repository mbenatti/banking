defmodule Banking.Transactions.TransferTest do
  @moduledoc """
  Tests for transfer logic
  """
  use Banking.Model.DataCase

  import Banking.Model.Factory

  alias Banking.Accounts.Transactions.{Deposit, Transfer}
  alias Banking.Model.Balances.{EventLoader, EventSchema}
  alias Banking.Model.Trades.{TradeSchema}
  alias Banking.Model.Repo
  alias Banking.Model.Enums.BankOperationEnum.Type

  describe "create/3" do
    test "success" do
      account = insert(:account)
      account2 = insert(:account)

      deposit1 = Decimal.new("1000.0000")

      assert {:ok, _} = Deposit.create(account.id, deposit1)

      assert {:ok, {transfer_issued, transfer_received}} =
               Transfer.create(account.id, account2.email, deposit1)

      events = Repo.all(EventSchema)
      trades = Repo.all(TradeSchema)

      assert Enum.count(events) == 3
      assert Enum.count(trades) == 3

      transfer_event = Repo.get(EventSchema, transfer_issued.balance_event_id)
      assert transfer_event.type == Type.TransferIssued

      transfer_event = Repo.get(EventSchema, transfer_received.balance_event_id)
      assert transfer_event.type == Type.TransferReceived

      last_event = EventLoader.get_last_event_by_account(account.id)
      assert last_event.balance == Decimal.new("0.0000")
    end

    test "fail: without balance" do
      account = insert(:account)
      account2 = insert(:account)

      deposit1 = Decimal.new("1000.0000")

      assert {:ok, _} = Deposit.create(account.id, deposit1)

      assert {:error, changeset} =
               Transfer.create(account.id, account2.email, Decimal.new("1000.1000"))

      refute changeset.valid?

      assert changeset.errors == [
               balance:
                 {"must be greater than or equal to %{number}",
                  [validation: :number, kind: :greater_than_or_equal_to, number: 0]}
             ]

      events = Repo.all(EventSchema)
      trades = Repo.all(TradeSchema)

      assert Enum.count(events) == 1
      assert Enum.count(trades) == 1

      last_event = EventLoader.get_last_event_by_account(account.id)

      assert last_event.balance == Decimal.new(deposit1)
    end
  end
end

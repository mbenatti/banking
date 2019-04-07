defmodule Banking.Model.Balances.EventMutatorTest do
  @moduledoc """
  Tests for write operations of balances event context
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Balances.EventMutator
  alias Banking.Model.Enums.BankOperationEnum.Type

  import Banking.Model.Factory

  describe("create/1") do
    test "valid params" do
      account = insert(:account)
      quantity_moved = "100.00"
      params = %{quantity_moved: quantity_moved, account_id: account.id, type: Type.Deposit}

      {:ok, event} = EventMutator.create(params)

      refute event.id == nil
      assert event.balance == Decimal.new(quantity_moved)
    end

    test "invalid params" do
      params = %{
        type: Type.Deposit
      }

      {:error, changeset} = EventMutator.create(params)

      refute changeset.valid?

      assert changeset.errors == [
               quantity_moved: {"can't be blank", [validation: :required]},
               account_id: {"can't be blank", [validation: :required]}
             ]
    end

    test "cast quantity_moved" do
      account = insert(:account)
      quantity_moved = "100.0000"
      params = %{quantity_moved: quantity_moved, account_id: account.id, type: Type.Deposit}

      {:ok, event1} = EventMutator.create(params)

      qty_withdrawal = "50.0000"

      params2 = %{
        quantity_moved: qty_withdrawal,
        parent_id: event1.id,
        account_id: account.id,
        type: Type.Withdrawal
      }

      {:ok, event2} = EventMutator.create(params2)

      assert event2.balance == Decimal.min(quantity_moved, qty_withdrawal)
      assert event2.quantity_moved == %Decimal{Decimal.new(qty_withdrawal) | sign: -1}
    end
  end
end

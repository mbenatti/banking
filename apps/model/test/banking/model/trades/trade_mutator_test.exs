defmodule Banking.Model.Trades.TradeMutatorTest do
  @moduledoc """
  Tests for writing operations on `t:Banking.Model.Trades.TradeSchema.t/0`
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Trades.TradeMutator

  import Banking.Model.Factory

  describe("create/1") do
    test "valid params" do
      event = insert(:balances_event)
      quantity_moved = "100.00"

      params = %{
        quantity: quantity_moved,
        account_id: event.account_id,
        balance_event_id: event.id
      }

      {:ok, trade} = TradeMutator.create(params, event.type)

      refute is_nil(trade.id)
      refute is_nil(trade.account_id)
      refute is_nil(trade.balance_event_id)
    end

    test "invalid params" do
      event = insert(:balances_event)

      {:error, changeset} = TradeMutator.create(%{}, event.type)

      refute changeset.valid?

      assert changeset.errors == [
               account_id: {"can't be blank", [validation: :required]},
               balance_event_id: {"can't be blank", [validation: :required]}
             ]
    end
  end
end

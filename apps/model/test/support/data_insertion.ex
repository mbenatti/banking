defmodule Banking.Model.DataInsertion do
  @moduledoc """
  Insert Data for test purposes
  """

  import Banking.Model.Factory

  @doc false
  def create_trade() do
    event = insert(:balances_event)

    insert(:trade,
      account: event.account,
      account_id: event.account_id,
      balance_event: event,
      balance_event_id: event.id,
      quantity: event.quantity_moved
    )
  end

  @doc false
  def create_trade_with_parent(trade) do
    event =
      insert(:balances_event,
        account_id: trade.balance_event.account_id,
        account: trade.balance_event.account
      )

    insert(:trade,
      account: event.account,
      account_id: event.account_id,
      balance_event: event,
      balance_event_id: event.id,
      quantity: event.quantity_moved
    )
  end

  @doc false
  def create_trade_with_parent(trade, days_shift) do
    event =
      insert(:balances_event,
        account_id: trade.balance_event.account_id,
        account: trade.balance_event.account,
        inserted_at: Timex.shift(Timex.now(), days: days_shift)
      )

    insert(:trade,
      account: event.account,
      account_id: event.account_id,
      balance_event: event,
      balance_event_id: event.id,
      quantity: event.quantity_moved,
      inserted_at: Timex.shift(Timex.now(), days: days_shift)
    )
  end
end

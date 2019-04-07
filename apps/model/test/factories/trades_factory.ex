defmodule Banking.Model.TradeFactory do
  @moduledoc """
  Factory to create a new Trade.

    import Banking.Model.Factory

    event = insert(:trade)
  """

  alias Banking.Model.Trades.TradeSchema

  defmacro __using__(_opts) do
    quote do
      def trade_factory do
        account = insert(:account)
        balance = Enum.random(1..1000)

        balance_event =
          insert(:balances_event,
            balance: balance,
            quantity_moved: balance,
            account: account,
            account_id: account.id
          )

        %TradeSchema{
          account: account,
          account_id: account.id,
          transfer_account: nil,
          transfer_account_id: nil,
          balance_event: balance_event,
          balance_event_id: balance_event.id
        }
      end
    end
  end
end

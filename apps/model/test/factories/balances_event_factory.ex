defmodule Banking.Model.BalanceEventFactory do
  @moduledoc """
  Factory to create a new Balance Event.

    import Banking.Model.Factory

    event = insert(:balances_event)
  """

  alias Banking.Model.Balances.EventSchema
  alias Banking.Model.Enums.BankOperationEnum.Type

  defmacro __using__(_opts) do
    quote do
      def balances_event_factory do
        account = build(:account)

        balance = Enum.random(1..1000)

        %EventSchema{
          account: account,
          account_id: account.id,
          balance: balance,
          quantity_moved: balance,
          type: Type.Deposit,
          parent: nil,
          parent_id: nil
        }
      end
    end
  end
end

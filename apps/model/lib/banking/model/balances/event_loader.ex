defmodule Banking.Model.Balances.EventLoader do
  @moduledoc """
  Execute read operations on database for Balance Event context.
  """

  alias Banking.Model.Balances.{EventQueries, EventSchema}
  alias Banking.Model.Repo

  @doc """
  Get an Balance Event `t:Banking.Model.Balances.EventSchema.t/0`

  ## Examples

      iex> EventLoader.get(100)
      nil

      iex> EventLoader.get(1)
      %Banking.Model.Balances.EventSchema{
      __meta__: #Ecto.Schema.Metadata<:loaded, "balances_event">,
      account: #Ecto.Association.NotLoaded<association :account is not loaded>,
      account_id: 2,
      balance: #Decimal<100.0000>,
      id: 1,
      inserted_at: ~N[2019-04-07 03:33:00],
      parent: #Ecto.Association.NotLoaded<association :parent is not loaded>,
      parent_id: nil,
      quantity_moved: #Decimal<100.0000>,
      type: Banking.Model.Enums.BankOperationEnum.Type.Deposit,
      updated_at: ~N[2019-04-07 03:33:00]
      }


  """
  @spec get(integer) :: EventSchema.t() | nil
  def get(event_id) do
    EventQueries.all()
    |> Repo.get(event_id)
  end

  @doc """
  Get the last  by email

  ## Examples

      iex> EventLoader.get_last_event_by_account(2)
      %Banking.Model.Balances.EventSchema{
      __meta__: #Ecto.Schema.Metadata<:loaded, "balances_event">,
      account: #Ecto.Association.NotLoaded<association :account is not loaded>,
      account_id: 2,
      balance: #Decimal<100.0000>,
      id: 1,
      inserted_at: ~N[2019-04-07 03:33:00],
      parent: #Ecto.Association.NotLoaded<association :parent is not loaded>,
      parent_id: nil,
      quantity_moved: #Decimal<100.0000>,
      type: Banking.Model.Enums.BankOperationEnum.Type.Deposit,
      updated_at: ~N[2019-04-07 03:33:00]
      }

      iex> EventLoader.get_last_event_by_account(3)
      nil

  """
  @spec get_last_event_by_account(Integer.t()) :: EventSchema.t() | nil
  def get_last_event_by_account(account_id) do
    account_id
    |> EventQueries.get_last_by_account_id()
    |> Repo.one()
  end
end

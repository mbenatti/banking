defmodule Banking.Model.Balances.EventMutator do
  @moduledoc """
  Responsible for operation on database like insert, update, delete for balances event context.
  """

  alias Banking.Model.Balances.EventSchema
  alias Banking.Model.Repo

  @doc """
  Create an `t:Banking.Model.Balances.EventSchema.t/0`

  ## Examples

      iex> params = %{quantity_moved: 100, account_id: account.id, type: Type.Deposit}
      iex> EventMutator.create(params)
      {:ok,
      %Banking.Model.Balances.EventSchema{
       __meta__: #Ecto.Schema.Metadata<:loaded, "balances_event">,
       account: #Ecto.Association.NotLoaded<association :account is not loaded>,
       account_id: 2,
       balance: #Decimal<100>,
       id: 1,
       inserted_at: ~N[2019-04-07 03:33:00],
       parent: #Ecto.Association.NotLoaded<association :parent is not loaded>,
       parent_id: nil,
       quantity_moved: #Decimal<100>,
       type: Banking.Model.Enums.BankOperationEnum.Type.Deposit,
       updated_at: ~N[2019-04-07 03:33:00]
      }}

  """
  @spec create(Map.t()) :: {:ok, EventSchema.t()} | {:error, Changeset.t()}
  def create(attrs) do
    %EventSchema{}
    |> EventSchema.changeset(attrs)
    |> Repo.insert()
  end
end

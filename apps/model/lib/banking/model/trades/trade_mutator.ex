defmodule Banking.Model.Trades.TradeMutator do
  @moduledoc """
  Responsible for operation on database like insert, update, delete for balances event context.
  """

  alias Banking.Model.Enums.BankOperationEnum
  alias Banking.Model.Trades.TradeSchema
  alias Banking.Model.Repo

  @doc """
  Create an `t:Banking.Model.Trades.TradeSchema.t/0`

  See more about the `type` on `t:Banking.Model.Enums.BankOperationEnum.t/0`

  ## Examples

      iex> {:ok, trade} = TradeMutator.create(trade_params, Type.Deposit)
      {:ok,
      %Banking.Model.Trades.TradeSchema{
       __meta__: #Ecto.Schema.Metadata<:loaded, "trades">,
       account: #Ecto.Association.NotLoaded<association :account is not loaded>,
       account_id: 4,
       balance_event: #Ecto.Association.NotLoaded<association :balance_event is not loaded>,
       balance_event_id: 3,
       id: 1,
       inserted_at: ~N[2019-04-07 07:19:22],
       transfer_account: #Ecto.Association.NotLoaded<association :transfer_account is not loaded>,
       transfer_account_id: nil,
       updated_at: ~N[2019-04-07 07:19:22]
      }}
  """
  @spec create(Map.t(), BankOperationEnum.t()) :: {:ok, TradeSchema.t()} | {:error, Changeset.t()}
  def create(attrs, event_type) do
    %TradeSchema{}
    |> TradeSchema.changeset(attrs, event_type)
    |> Repo.insert()
  end
end

defmodule Banking.Accounts.Transactions.Deposit do
  @moduledoc """
  The way to create a Bank Operation Deposit

  Each Deposit create an `t:Banking.Model.Balances.EventSchema.t/0` of `Type.Deposit` and Update the balance
  according with the Last Balance Event

  see `create/2`
  """

  alias Banking.Model.Balances.EventMutator
  alias Banking.Model.Trades.{TradeSchema, TradeMutator}
  alias Banking.Model.Enums.BankOperationEnum.Type
  alias Ecto.Changeset
  alias Banking.Model.Repo

  @doc """
  Build and write a Deposit operation on Database

  This is the unique way to create a Deposit, this function creates a `t:Banking.Model.Balances.EventSchema.t/0`
  and `t:Banking.Model.Trades.TradesSchema.t/0` representing Trade on Account.

  The `account_id` is provided by the Auth System and shouldn't have be provided in other way.

  ## Parameters

      - account_id: Value representing the account ID.
      - amount: Decimal amount of deposit.

  """
  @spec create(String.t(), Decimal.t()) :: {:ok, TradeSchema.t()} | {:error, Changeset.t()}
  def create(account_id, amount) do
    attrs = %{account_id: account_id, quantity_moved: amount, type: Type.Deposit}

    parse_response(
      Repo.transaction(fn ->
        with {:ok, event} <- EventMutator.create(attrs),
             {:ok, trade} <-
               TradeMutator.create(
                 %{
                   account_id: event.account_id,
                   balance_event_id: event.id
                 },
                 event.type
               ) do
          {:ok, trade}
        else
          err -> Repo.rollback(err)
        end
      end)
    )
  end

  @spec parse_response(any) :: {:ok, TradeSchema.t()} | {:error, any()}
  defp parse_response({:ok, response}), do: response
  defp parse_response({:error, {:error, error}}), do: {:error, error}
  defp parse_response({:error, err}), do: {:error, err}
end

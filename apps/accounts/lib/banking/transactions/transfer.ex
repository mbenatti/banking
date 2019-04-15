defmodule Banking.Accounts.Transactions.Transfer do
  @moduledoc """
  Do the transaction between bank account's

  The transfer creates a debit on a bank account that issue the transfer and a credit on a account receiving the transfer.

  Each Transfer create a `t:Banking.Model.Balances.EventSchema.t/0` of `Type.TransferIssued` and `Type.TransferReceived`
  depending of the side and Update the balance on changeset according with the Last Balance Event, this occurs on Both
  sides on a transference.

  Is not allowed negative Balance on debiting an account and wil return an {:error, changeset} and all
  operations(inside a transaction) will be rollback from database.

  see `create/3`
  """

  alias Banking.Model.Balances.EventMutator
  alias Banking.Model.Trades.{TradeSchema, TradeMutator}
  alias Banking.Model.Accounts.{AccountLoader, AccountSchema}
  alias Banking.Model.Enums.BankOperationEnum.Type
  alias Ecto.Changeset
  alias Banking.Model.Repo

  @doc """
  Build and write the Transfer on Database between two accounts,

  This is the unique way to create a Transference, this function create a `t:Banking.Model.Balances.EventSchema.t/0`
  and `t:Banking.Model.Trades.TradesSchema.t/0` representing Trade on Account, on both sides

  The `account_id` is provided by the Auth System and shouldn't have be provided in other way

  ## Parameters

      - account_id: Value representing the account ID to issue the transfer
      - account_transfer_email: String representing the account receiving the transference.
      - amount: Decimal amount of transference
  """
  @spec create(Integer.t(), String.t(), Decimal.t()) ::
          {:ok, {TradeSchema.t(), TradeSchema.t()}} | {:error, Changeset.t()}
  def create(account_id, account_transfer_email, amount) do
    attrs_transfer_issued = %{
      account_id: account_id,
      quantity_moved: amount,
      type: Type.TransferIssued
    }

    case AccountLoader.get_by_email(account_transfer_email) do
      nil ->
        {:error, "Account transfer not found"}

      %AccountSchema{id: id_transfer_account} ->
        attrs_transfer_received = %{
          account_id: id_transfer_account,
          quantity_moved: amount,
          type: Type.TransferReceived
        }

        do_transfer(
          attrs_transfer_issued,
          attrs_transfer_received,
          id_transfer_account,
          account_id
        )
    end
  end

  defp do_transfer(
         attrs_transfer_issued,
         attrs_transfer_received,
         id_transfer_account,
         account_id
       ) do
    parse_response(
      Repo.transaction(fn ->
        with {:ok, balance_event_transfered} <- EventMutator.create(attrs_transfer_issued),
             {:ok, trade_issued} <-
               TradeMutator.create(
                 %{
                   account_id: balance_event_transfered.account_id,
                   balance_event_id: balance_event_transfered.id,
                   transfer_account_id: id_transfer_account
                 },
                 balance_event_transfered.type
               ),
             {:ok, balance_event_received} <- EventMutator.create(attrs_transfer_received),
             {:ok, trade_received} <-
               TradeMutator.create(
                 %{
                   account_id: balance_event_received.account_id,
                   balance_event_id: balance_event_received.id,
                   transfer_account_id: account_id
                 },
                 balance_event_received.type
               ) do
          {:ok, {trade_issued, trade_received}}
        else
          err -> Repo.rollback(err)
        end
      end)
    )
  end

  @spec parse_response(any) :: {:ok, {TradeSchema.t(), TradeSchema.t()}} | {:error, any()}
  defp parse_response({:ok, response}), do: response
  defp parse_response({:error, {:error, error}}), do: {:error, error}
  defp parse_response({:error, err}), do: {:error, err}
end

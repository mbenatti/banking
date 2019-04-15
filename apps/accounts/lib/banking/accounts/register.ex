defmodule Banking.Accounts.Register do
  @moduledoc """
  Responsible for business logic of Account registration
  """

  alias Banking.Accounts.Transactions.Deposit
  alias Banking.Model.Accounts.AccountMutator

  @doc """
  Create the user on Database
  """
  @spec create(Map.t()) :: {:error, Ecto.Changeset.t()} | {:ok, String.t()}
  def create(params) do
    with {:ok, account} <- AccountMutator.create(params),
         {:ok, _} <- Deposit.create(account.id, get_register_deposit()) do
      {:ok, account}
    end
  end

  defp get_register_deposit() do
    :accounts
    |> Application.get_env(:register_deposit)
    |> Decimal.new()
  end
end

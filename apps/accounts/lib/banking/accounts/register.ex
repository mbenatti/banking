defmodule Banking.Accounts.Register do
  @moduledoc """
  Responsible for business logic regarded Account registration
  """

  alias Banking.Model.Accounts.AccountMutator

  @doc """
  Create the user on Database
  """
  @spec create(Map.t()) :: {:error, Ecto.Changeset.t()} | {:ok, String.t()}
  def create(params) do
    with {:ok, account} <- AccountMutator.create(params) do
      # Send email
      # Add balance to account
      {:ok, account}
    end
  end
end

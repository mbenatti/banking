defmodule Banking.Model.Accounts.AccountLoader do
  @moduledoc """
  Execute read operations on database for accounts context.
  """

  alias Banking.Model.Accounts.{AccountQueries, AccountSchema}
  alias Banking.Model.Repo

  @doc """
  Get an Account

  ## Examples

      iex> AccountLoader.get(30)
      nil

      iex> AccountLoader.get(4)
      %Banking.Model.Accounts.AccountSchema{
        __meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
        email: "marcos2@email.com",
        id: 4,
        inserted_at: ~N[2019-03-21 23:15:51],
        name: "Marcos",
        password: "$argon2id$v=19$m=131072,t=8,p=4$QcllWjHSmhOfwyZMdSIBMA$uhTIarDAULVx9ZcytwGzbbGWZKmZnIHi30tEnLSSiqk",
        updated_at: ~N[2019-03-21 23:15:51]
       }

  """
  @spec get(integer) :: AccountSchema.t() | nil
  def get(account_id) do
    AccountQueries.all()
    |> Repo.get(account_id)
  end

  @doc """
  Get an Account by email

  ## Examples

      iex> AccountLoader.get_by_email("marcos2@email.com")
      %Banking.Model.Accounts.AccountSchema{
        __meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
        email: "marcos2@email.com",
        id: 4,
        inserted_at: ~N[2019-03-21 23:15:51],
        name: "Marcos",
        password: "$argon2id$v=19$m=131072,t=8,p=4$QcllWjHSmhOfwyZMdSIBMA$uhTIarDAULVx9ZcytwGzbbGWZKmZnIHi30tEnLSSiqk",
        updated_at: ~N[2019-03-21 23:15:51]
      }

  """
  @spec get(String.t()) :: AccountSchema.t() | nil
  def get_by_email(email) do
    email
    |> AccountQueries.get_by_email()
    |> Repo.one()
  end
end

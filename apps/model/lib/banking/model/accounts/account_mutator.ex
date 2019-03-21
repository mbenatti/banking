defmodule Banking.Model.Accounts.AccountMutator do
  @moduledoc """
  Responsible for operation on database like insert, update, delete for accounts context.
  """

  alias Banking.Model.Accounts.AccountSchema
  alias Banking.Model.Repo
  alias Ecto.Changeset

  @doc """
  Create an account on database

  ## Examples

      iex> AccountMutator.create(%{name: "Marcos", email: "marcos@email.com", password: "mypassword"})
      {:error,
       #Ecto.Changeset<
         action: :insert,
         changes: %{
           email: "marcos@email.com",
           name: "Marcos",
           password: "$argon2id$v=19$m=131072,t=8,p=4$oRy1BVTlKBjma5xT7SPw/w$REsbR3UuDWGikY0cSCy/muHmKeBYEpQGGWECcdsR9Yg"
         },
         errors: [
           email: {"has already been taken",
            [constraint: :unique, constraint_name: "accounts_email_index"]}
         ],
         data: #Banking.Model.Accounts.AccountSchema<>,
         valid?: false
       >}

      iex> AccountMutator.create(%{name: "Marcos", email: "marcos2@email.com", password: "mypassword"})
      {:ok,
       %Banking.Model.Accounts.AccountSchema{
         __meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
         email: "marcos2@email.com",
         id: 4,
         inserted_at: ~N[2019-03-21 23:15:51],
         name: "Marcos",
         password: "$argon2id$v=19$m=131072,t=8,p=4$QcllWjHSmhOfwyZMdSIBMA$uhTIarDAULVx9ZcytwGzbbGWZKmZnIHi30tEnLSSiqk",
         updated_at: ~N[2019-03-21 23:15:51]
       }}

  """
  @spec create(Map.t()) :: {:ok, AccountSchema.t()} | {:error, Changeset.t()}
  def create(attrs) do
    %AccountSchema{}
    |> AccountSchema.changeset(attrs)
    |> Repo.insert()
  end
end

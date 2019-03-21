defmodule Banking.Model.Accounts.AccountSchema do
  @moduledoc """
  A Client Account

  This is the abstraction of client account on Bank, define their schema and changeset validation.
  Represented on database as `accounts` table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @typedoc """
  The `Banking.Model.Accounts.AccountSchema` struct.
  """
  @type t :: %__MODULE__{}

  schema "accounts" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)

    timestamps()
  end

  @required [:name, :email, :password]

  @doc """
  Changeset for an account

  ## Examples

      iex> alias Banking.Model.Accounts.AccountSchema
      iex> AccountSchema.changeset %AccountSchema{}, %{name: "Marcos", email: "marcos@email.com", password: "123456"}
      #Ecto.Changeset<
        action: nil,
        changes: %{
          email: "marcos@email.com",
          name: "Marcos",
          password: "$argon2id$v=19$m=131072,t=8,p=4$Bqrd4z4KZnk3Z9yJfoc0nQ$xs0/du78YpMWDoj11T5cNgT1KCCYEdFzwjSiXNDYkAg"
        },
        errors: [],
        data: #Banking.Model.Accounts.AccountSchema<>,
        valid?: true
      >

      iex> AccountSchema.changeset %AccountSchema{}, %{name: "Marcos", email: "marcos@email.com"}
      #Ecto.Changeset<
        action: nil,
        changes: %{email: "marcos@email.com", name: "Marcos"},
        errors: [password: {"can't be blank", [validation: :required]}],
        data: #Banking.Model.Accounts.AccountSchema<>,
        valid?: false
      >

  """
  @spec changeset(t(), Map.t()) :: Changeset.t()
  def changeset(account \\ __MODULE__, params \\ %{}) do
    account
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end

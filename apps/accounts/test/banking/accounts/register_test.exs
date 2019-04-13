defmodule Banking.Accounts.RegisterTest do
  use Banking.Model.DataCase

  alias Banking.Accounts.Register
  alias Banking.Accounts.Transactions.Statement

  describe "create/1" do
    test "with valid attributes" do
      params = %{
        name: Faker.Name.PtBr.name(),
        password: Faker.UUID.v4(),
        email: Faker.Internet.email()
      }

      {:ok, account} = Register.create(params)

      refute account.id == nil
    end

    test "with initial deposit" do
      params = %{
        name: Faker.Name.PtBr.name(),
        password: Faker.UUID.v4(),
        email: Faker.Internet.email()
      }

      {:ok, account} = Register.create(params)
      %{balance: balance} = Statement.get_balance(account.id)

      refute account.id == nil

      assert balance == get_register_deposit()
    end

    test "with invalid attributes" do
      params = %{name: nil, password: Faker.UUID.v4(), email: "not_an_email"}

      assert {:error, changeset} = Register.create(params)

      refute changeset.valid?

      assert changeset.errors == [
               email: {"has invalid format", [validation: :format]},
               name: {"can't be blank", [validation: :required]}
             ]
    end
  end

  defp get_register_deposit() do
    :accounts
    |> Application.get_env(:register_deposit)
    |> Decimal.new()
    |> Decimal.add(Decimal.new("0.0000"))
  end
end

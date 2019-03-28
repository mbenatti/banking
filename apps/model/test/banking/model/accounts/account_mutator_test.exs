defmodule Banking.Model.Accounts.AccountMutatorTest do
  @moduledoc"""
  Tests for write operations on account
  """
  use Banking.Model.DataCase

  alias Banking.Model.Accounts.{AccountMutator, AccountSchema}

  describe("create/1") do
    test "with valid attributes" do
      params = %{
        name: Faker.Name.PtBr.name(),
        password: Faker.UUID.v4(),
        email: Faker.Internet.email()
      }

      {:ok, account} = AccountMutator.create(params)

      refute account.id == nil
    end

    test "validate hash password" do
      my_password = Faker.UUID.v4()

      params = %{
        name: Faker.Name.PtBr.name(),
        password: my_password,
        email: Faker.Internet.email()
      }

      {:ok, %AccountSchema{password: hashed_password}} = AccountMutator.create(params)

      assert Argon2.verify_pass(my_password, hashed_password)
    end

    test "with invalid attributes" do
      params = %{name: nil, password: Faker.UUID.v4(), email: "not_an_email"}

      assert {:error, changeset} = AccountMutator.create(params)

      refute changeset.valid?

      assert changeset.errors == [
               email: {"has invalid format", [validation: :format]},
               name: {"can't be blank", [validation: :required]}
             ]
    end
  end
end

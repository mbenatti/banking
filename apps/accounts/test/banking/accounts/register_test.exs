defmodule Banking.Accounts.RegisterTest do
  use Banking.Model.DataCase

  alias Banking.Accounts.Register

  describe "create/1" do
    test "with valid attributes" do
      params = %{
        name: Faker.Name.PtBr.name(),
        password: Faker.UUID.v4(),
        email: Faker.Internet.email()
      }

      {:ok, client} = Register.create(params)

      refute client.id == nil
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
end

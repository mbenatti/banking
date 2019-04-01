defmodule Banking.Model.Accounts.AccountSchemaTest do
  @moduledoc """
  Tests validating the schema changeset
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Accounts.AccountSchema

  describe("changeset/2") do
    test "valid changeset" do
      params = %{
        name: Faker.Name.name(),
        email: Faker.Internet.email(),
        password: Faker.UUID.v4()
      }

      changeset = AccountSchema.changeset(%AccountSchema{}, params)

      assert changeset.valid? == true
      assert errors_on(changeset) == %{}
    end

    test "validate required field" do
      params = %{
        name: nil,
        email: Faker.Internet.email(),
        password: Faker.UUID.v4()
      }

      changeset = AccountSchema.changeset(%AccountSchema{}, params)
      expected = %{name: ["can't be blank"]}

      assert changeset.valid? == false
      assert errors_on(changeset) == expected
    end

    test "test invalid email" do
      params = %{
        name: Faker.Name.name(),
        email: "someemailemail.com",
        password: Faker.UUID.v4()
      }

      changeset = AccountSchema.changeset(%AccountSchema{}, params)
      expected = %{email: ["has invalid format"]}

      assert changeset.valid? == false
      assert errors_on(changeset) == expected
    end

    test "test invalid password length" do
      params = %{
        name: Faker.Name.name(),
        email: Faker.Internet.email(),
        password: "12345"
      }

      changeset = AccountSchema.changeset(%AccountSchema{}, params)
      expected = %{password: ["should be at least 8 character(s)"]}

      assert changeset.valid? == false
      assert errors_on(changeset) == expected
    end
  end
end

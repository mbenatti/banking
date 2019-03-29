defmodule Banking.Model.Accounts.AccountLoaderTest do
  @moduledoc"""
  Tests for read operations on account
  """
  use Banking.Model.DataCase

  alias Banking.Model.Accounts.{AccountLoader, AccountSchema}

  import Banking.Model.Factory

  describe("get account") do
    test "by id" do
      %AccountSchema{id: id_inserted, name: name_inserted} = insert(:account)

      %AccountSchema{id: id, name: name} = AccountLoader.get(id_inserted)

      assert id_inserted == id
      assert name_inserted == name
    end

    test "by email" do
      %AccountSchema{id: id_inserted, name: name_inserted, email: email} = insert(:account)

      %AccountSchema{id: id, name: name} = AccountLoader.get_by_email(email)

      assert id_inserted == id
      assert name_inserted == name
    end
  end

  describe("get_all/2") do
    test "retrieve accounts" do
      insert_list(2, :account)

      accounts = AccountLoader.get_all()

      assert Enum.count(accounts) == 2
    end

    test "without accounts" do
      accounts = AccountLoader.get_all()

      assert accounts == []
    end
  end
end

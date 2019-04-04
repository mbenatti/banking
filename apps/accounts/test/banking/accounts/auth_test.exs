defmodule Banking.Accounts.AuthTest do
  use Banking.Model.DataCase

  alias Banking.Accounts.Auth

  import Banking.Model.Factory

  describe "authenticate/2" do
    test "with valid credentials" do
      password = "myv4lid.p4ss"
      client = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      {:ok, client} = Auth.authenticate(client.email, password)

      refute client.id == nil
    end

    test "with invalid credentials" do
      password = "myv4lid.p4ss"
      invalid_password = "invalid"
      client = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      {:error, msg} = Auth.authenticate(client.email, invalid_password)

      assert msg == :unauthorized
    end
  end
end

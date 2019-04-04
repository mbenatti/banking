defmodule Banking.APIWeb.Auth.AuthControllerTest do
  use Banking.APIWeb.ConnCase

  import Banking.Model.Factory

  describe "auth" do
    test "with valid credentials", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      params = %{
        username: account.email,
        password: password
      }

      conn = post(conn, "/api/auth", params)

      assert json = json_response(conn, 200)
      assert json["token"] != nil
    end

    test "with invalid username", %{conn: conn} do
      password = "12345678"
      insert(:account, %{email: "myemail@test.com", password: Argon2.hash_pwd_salt(password)})

      params = %{
        username: "my@invalid.mail",
        password: password
      }

      conn = post(conn, "/api/auth", params)

      assert %{"message" => msg} = json_response(conn, 422)
      assert message = "Username or/and password are invalid"
    end

    test "with invalid password", %{conn: conn} do
      password = "12345678"
      email = "myemail@test.com"
      insert(:account, %{email: email, password: Argon2.hash_pwd_salt(password)})

      params = %{
        username: email,
        password: "invalidp4ss"
      }

      conn = post(conn, "/api/auth", params)

      assert %{"message" => msg} = json_response(conn, 422)
      assert message = "Username or/and password are invalid"
    end
  end
end

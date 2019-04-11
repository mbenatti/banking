defmodule Banking.APIWeb.Auth.TransactionControllerTest do
  @moduledoc false
  use Banking.APIWeb.ConnCase

  import Banking.Model.Factory

  describe "auth" do
    test "Unauthorized", %{conn: conn} do
      %{resp_body: body} = post(conn, "/api/priv/deposit", %{})

      assert Jason.decode!(body) == %{"errors" => %{"detail" => "Unauthorized"}}
    end
  end

  describe "deposit" do
    test "success", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/deposit", %{amount: "1.000,0"})

      assert json = json_response(conn, 200)
      assert json == %{"message" => "Deposit created"}
    end

    test "invalid", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/deposit", %{})

      assert json = json_response(conn, 422)
      assert json == %{"errors" => "Invalid request, please verify the request params"}
    end
  end

  describe "withdrawal" do
    test "success", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})
      insert(:balances_event, balance: 1000, account: account, account_id: account.id)

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/withdrawal", %{amount: "1.000,0"})

      assert json = json_response(conn, 200)
      assert json == %{"message" => "Withdrawal created"}
    end

    test "fail", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/withdrawal", %{amount: "1.000,0"})

      assert json = json_response(conn, 422)
      assert json == %{"errors" => %{"balance" => ["must be greater than or equal to 0"]}}
    end

    test "invalid", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/withdrawal", %{})

      assert json = json_response(conn, 422)
      assert json == %{"errors" => "Invalid request, please verify the request params"}
    end
  end

  describe "transfer" do
    test "success", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})
      account_transfer = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      insert(:balances_event, balance: 1000, account: account, account_id: account.id)

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/transfer", %{username: account_transfer.email, amount: "1.000,0"})

      assert json = json_response(conn, 200)
      assert json == %{"message" => "Transference successful"}
    end

    test "fail", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})
      account_transfer = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/transfer", %{username: account_transfer.email, amount: "1.000,0"})

      assert json = json_response(conn, 422)
      assert json == %{"errors" => %{"balance" => ["must be greater than or equal to 0"]}}
    end

    test "invalid", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post("/api/priv/withdrawal", %{})

      assert json = json_response(conn, 422)
      assert json == %{"errors" => "Invalid request, please verify the request params"}
    end
  end

  describe "bank statement" do
    test "get_balance", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      insert(:balances_event, balance: 1000, account: account, account_id: account.id)

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> get("/api/priv/balance", %{})

      assert json = json_response(conn, 200)
      assert json == %{"message" => "Balance: 1000.0000"}
    end

    test "get_statement", %{conn: conn} do
      password = "12345678"
      account = insert(:account, %{password: Argon2.hash_pwd_salt(password)})

      insert(:trade, account: account, account_id: account.id)
      insert(:trade, account: account, account_id: account.id)

      token = do_auth(conn, account.email, password)

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> get("/api/priv/statement", %{})

      assert %{"statement" => statements} = json_response(conn, 200)

      sample = List.first(statements)

      assert Enum.count(statements) == 2
      assert sample["description"] =~ "Deposit of"
      assert Map.has_key?(sample, "date")
      assert Map.has_key?(sample, "amount")
      assert Map.has_key?(sample, "balance")
      assert Map.has_key?(sample, "type")
    end
  end

  defp do_auth(conn, username, password) do
    params = %{
      username: username,
      password: password
    }

    conn = post(conn, "/api/auth", params)

    json = json_response(conn, 200)
    json["token"]
  end
end

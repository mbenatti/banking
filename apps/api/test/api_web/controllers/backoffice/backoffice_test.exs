defmodule Banking.APIWeb.Backoffice.BackofficeControllerTest do
  @moduledoc false

  use Banking.APIWeb.ConnCase

  import Banking.Model.Factory

  @username Application.get_env(:api, :backoffice_auth)[:username]
  @password Application.get_env(:api, :backoffice_auth)[:password]

  describe "auth" do
    test "with invalid credentials", %{conn: conn} do
      conn =
        conn
        |> get("/api/admin/report/daily")

      assert response(conn, 401) =~ "401 Unauthorized"
    end

    test "with valid credentials", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/api/admin/report/daily")

      assert json_response(conn, 200) == []
    end
  end

  describe "reports" do
    test "daily", %{conn: conn} do
      insert(:trade)

      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/api/admin/report/daily")

      assert [report] = json_response(conn, 200)

      assert Map.has_key?(report, "day_date")
      assert Map.has_key?(report, "deposit_amount")
      assert Map.has_key?(report, "transfer_issued_amount")
      assert Map.has_key?(report, "transfer_received_amount")
      assert Map.has_key?(report, "withdrawal_amount")
    end

    test "monthly", %{conn: conn} do
      insert(:trade)

      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/api/admin/report/monthly")

      assert [report] = json_response(conn, 200)

      assert Map.has_key?(report, "month_date")
      assert Map.has_key?(report, "deposit_amount")
      assert Map.has_key?(report, "transfer_issued_amount")
      assert Map.has_key?(report, "transfer_received_amount")
      assert Map.has_key?(report, "withdrawal_amount")
    end

    test "yearly", %{conn: conn} do
      insert(:trade)

      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/api/admin/report/yearly")

      assert [report] = json_response(conn, 200)

      assert Map.has_key?(report, "year_date")
      assert Map.has_key?(report, "deposit_amount")
      assert Map.has_key?(report, "transfer_issued_amount")
      assert Map.has_key?(report, "transfer_received_amount")
      assert Map.has_key?(report, "withdrawal_amount")
    end

    test "total", %{conn: conn} do
      insert(:trade)

      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/api/admin/report/total")

      assert report = json_response(conn, 200)

      assert Map.has_key?(report, "deposit_amount")
      assert Map.has_key?(report, "transfer_issued_amount")
      assert Map.has_key?(report, "transfer_received_amount")
      assert Map.has_key?(report, "withdrawal_amount")
    end
  end

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end
end

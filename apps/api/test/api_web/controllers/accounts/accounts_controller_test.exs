defmodule Banking.APIWeb.Accounts.AccountControllerTest do
  use Banking.APIWeb.ConnCase

  alias Banking.Model.Accounts.AccountSchema
  alias Banking.Model.Repo

  describe "create/2" do
    test "succesfull registration", %{conn: conn} do
      name = Faker.Name.name()

      params = %{
        "name" => name,
        "email" => Faker.Internet.email(),
        "password" => Faker.UUID.v4()
      }

      %Plug.Conn{status: status, resp_body: body} =
        conn
        |> post("/api/registration", params)

      assert status == 200
      assert body =~ "account_id"

      %{"account_id" => id} = Jason.decode!(body)

      account = Repo.get(AccountSchema, id)

      refute account == nil
      assert account.name == name
    end

    test "fail registration", %{conn: conn} do
      params = %{
        "name" => nil,
        "email" => Faker.Internet.email(),
        "password" => "123456"
      }

      %Plug.Conn{status: status, resp_body: body} =
        conn
        |> post("/api/registration", params)

      %{"errors" => errors} = Jason.decode!(body)

      assert status == 422

      assert errors == %{
               "name" => ["can't be blank"],
               "password" => ["should be at least 8 character(s)"]
             }
    end
  end
end

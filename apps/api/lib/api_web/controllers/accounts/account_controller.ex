defmodule Banking.APIWeb.AccountController do
  @moduledoc """
  Routes implementation for Account

  see `create/2`
  """

  use Banking.APIWeb, :controller

  alias Banking.Accounts.Register
  alias Plug.Conn

  action_fallback(Banking.APIWeb.FallbackController)

  @doc """
  Create an user

  ## Parameters

    -- conn: The connection
    -- params: The params provided by user containing the name, username(email) and password
  """
  @spec create(Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, %{} = params) do
    with {:ok, account} <- Register.create(params) do
      render(conn, "create.json", account: account)
    end
  end
end

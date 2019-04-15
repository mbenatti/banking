defmodule Banking.APIWeb.AuthController do
  @moduledoc """
  Authenticate an user

  see `create/2`
  """

  use Banking.APIWeb, :controller

  alias Banking.Accounts.Auth
  alias Banking.APIWeb.Guardian

  action_fallback(Banking.APIWeb.FallbackController)

  @doc """
  Authenticate an user

  ## Parameters

      - conn: The connection
      - params: The params provided by user containing the username(email) and password
  """
  @spec create(Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, %{"username" => username, "password" => password}) do
    with {:ok, account} <- Auth.authenticate(username, password) do
      {:ok, token, _claims} = generate_jwt_token(account)
      render(conn, "show.json", token: token)
    end
  end

  def create(_conn, _params) do
    {:error, :unauthorized}
  end

  # Generate a JWT token using the Guardian
  defp generate_jwt_token(account) do
    custom_claims = %{name: account.name}
    Guardian.encode_and_sign(account, custom_claims)
  end
end

defmodule Banking.APIWeb.FallbackController do
  use Phoenix.Controller

  alias Banking.APIWeb.AuthView
  alias Banking.APIWeb.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, msg}) when is_bitstring(msg) do
    conn
    |> put_view(ErrorView)
    |> render("error.json", message: msg)
  end

  def call(conn, {:error, :invalid_request}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", message: "Invalid request, please verify the request params")
  end

  def call(conn, {:error, :not_found}) do
    invalid_login_reply(conn)
  end

  def call(conn, {:error, :unauthorized}) do
    invalid_login_reply(conn)
  end

  defp invalid_login_reply(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AuthView)
    |> render("invalid.json")
  end
end

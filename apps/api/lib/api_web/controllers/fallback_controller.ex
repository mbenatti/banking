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

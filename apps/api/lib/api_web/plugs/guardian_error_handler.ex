defmodule Banking.APIWeb.Plugs.GuardianErrorHandler do
  @moduledoc """
  A plug to return the  unauthorized error when something wrong happens with
  Guardian
  """

  @behaviour Guardian.Plug.ErrorHandler

  use Phoenix.Controller, only: [render: 2, put_status: 2, put_view: 2]

  alias Banking.APIWeb.ErrorView

  @impl Guardian.Plug.ErrorHandler
  @doc """
  Handler when a auth error occuor, this will redirect to login screen
  """
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
    |> halt()
  end
end

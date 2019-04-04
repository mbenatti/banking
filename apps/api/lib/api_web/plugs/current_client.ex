defmodule Banking.APIWeb.Plugs.CurrentClient do
  @moduledoc """
  A plug to add the current client in the plug connection
  """

  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _opts) do
    current_client = Guardian.Plug.current_resource(conn)

    if is_nil(current_client) do
      conn
    else
      assign(conn, :current_client, current_client)
    end
  end
end

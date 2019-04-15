defmodule Banking.APIWeb.AuthView do
  @moduledoc false
  use Banking.APIWeb, :view

  def render("show.json", %{token: token}) do
    %{token: token}
  end

  def render("invalid.json", _assigns) do
    %{
      message: "Username or/and password are invalid"
    }
  end
end

defmodule Banking.APIWeb.Router do
  use Banking.APIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Banking.APIWeb do
    pipe_through :api
  end
end

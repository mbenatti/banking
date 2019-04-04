defmodule Banking.APIWeb.Router do
  use Banking.APIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(Banking.APIWeb.Pipeline.Auth)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Banking.APIWeb.Plugs.CurrentClient)
  end

  scope "/api", Banking.APIWeb do
    pipe_through :api

    post "/registration", AccountController, :create

    scope "/auth" do
      post "/", AuthController, :create
    end

    scope "/priv", AccountController do
      pipe_through [:auth, :ensure_auth]

    end
  end
end

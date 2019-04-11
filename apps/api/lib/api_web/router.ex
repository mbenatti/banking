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

  pipeline :auth_backoffice do
    plug BasicAuth, use_config: {:api, :backoffice_auth}
  end

  scope "/api", Banking.APIWeb do
    pipe_through :api

    post "/registration", AccountController, :create

    scope "/auth" do
      post "/", AuthController, :create
    end

    scope "/priv" do
      pipe_through [:auth, :ensure_auth]

      post "/deposit", TransactionController, :deposit
      post "/withdrawal", TransactionController, :withdrawal
      post "/transfer", TransactionController, :transfer
      get "/balance", TransactionController, :balance
      get "/statement", TransactionController, :statement
    end

    scope "/admin" do
      pipe_through [:auth_backoffice]

      get "/report/daily", BackofficeController, :daily_report
      get "/report/monthly", BackofficeController, :monthly_report
      get "/report/yearly", BackofficeController, :yearly_report
      get "/report/total", BackofficeController, :total_report
    end
  end
end

defmodule Banking.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      deps: deps(),

      # Docs
      name: "banking",
      source_url: "https://github.com/mbenatti/",
      homepage_url: "https://github.com/mbenatti/",
      docs: [
        # The main page in the docs
        main: "overview",
        logo: "assets/bank.png",
        assets: "assets",
        extras: [
          "README.md",
          "apps/accounts/ACCOUNTS.md",
          "apps/api/API.md",
          "apps/backoffice/BACKOFFICE.md",
          "apps/email/EMAIL.md",
          "apps/model/MODEL.md"
        ],
        groups_for_modules: [
          API: [
            Banking.APIWeb.AccountController,
            Banking.APIWeb.AuthController,
            Banking.APIWeb.BackofficeController,
            Banking.APIWeb.TransactionController,
            Banking.APIWeb,
            Banking.APIWeb.Router.Helpers
          ],
          PLUGS: [
            Banking.APIWeb.Plugs.CurrentClient,
            Banking.APIWeb.Plugs.GuardianErrorHandler,
            Banking.APIWeb.Pipeline.Auth,
            Banking.APIWeb.Guardian.Plug
          ],
          ACCOUNTS: [Banking.Accounts.Auth, Banking.Accounts.Register],
          ACCOUNTS_TRANSACTION: [
            Banking.Accounts.Utils,
            Banking.Accounts.Transactions.Deposit,
            Banking.Accounts.Transactions.Withdrawal,
            Banking.Accounts.Transactions.Transfer,
            Banking.Accounts.Transactions.Statement
          ],
          BACKOFFICE: [Banking.Backoffice.Reports],
          EMAIL: [Banking.Email.WithdrawalEmail],
          MODEL_ACCOUNTS: [
            Banking.Model.Accounts.AccountLoader,
            Banking.Model.Accounts.AccountMutator,
            Banking.Model.Accounts.AccountQueries,
            Banking.Model.Accounts.AccountSchema
          ],
          MODEL_BALANCES: [
            Banking.Model.Balances.EventLoader,
            Banking.Model.Balances.EventMutator,
            Banking.Model.Balances.EventQueries,
            Banking.Model.Balances.EventSchema
          ],
          MODEL_TRADES: [
            Banking.Model.Trades.TradeLoader,
            Banking.Model.Trades.TradeMutator,
            Banking.Model.Trades.TradeQueries,
            Banking.Model.Trades.TradeSchema
          ],
          ENUMS: [
            Banking.Model.Enums.BankOperationEnum,
            Banking.Model.Enums.BankOperationEnum.Type,
            Banking.Model.Enums.BankOperationEnum.Type.Deposit,
            Banking.Model.Enums.BankOperationEnum.Type.Withdrawal,
            Banking.Model.Enums.BankOperationEnum.Type.TransferIssued,
            Banking.Model.Enums.BankOperationEnum.Type.TransferReceived
          ]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:timber, "~> 3.1"}
    ]
  end
end

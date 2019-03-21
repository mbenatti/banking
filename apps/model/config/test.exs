use Mix.Config

config :model, Banking.Model.Repo,
  database: "banking_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

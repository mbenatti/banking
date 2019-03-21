use Mix.Config

config :model, Banking.Model.Repo,
  database: "banking_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10

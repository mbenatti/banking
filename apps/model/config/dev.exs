use Mix.Config
# NOT Reproduce this in prod.exs, this will be saved one time at compile time
config :model, Banking.Model.Repo,
  database: System.get_env("BANKING_DB_NAME") || "banking_dev",
  username: System.get_env("BANKING_DB_USER") || "postgres",
  password: System.get_env("BANKING_DB_PASS") || "postgres",
  hostname: System.get_env("BANKING_DB_HOST") || "localhost",
  pool_size: System.get_env("BANKING_DB_POOL") || 10

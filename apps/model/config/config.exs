use Mix.Config

config :model,
  ecto_repos: [Banking.Model.Repo]

import_config "#{Mix.env()}.exs"

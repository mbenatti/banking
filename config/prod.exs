use Mix.Config

config :logger,
  backends: [Timber.LoggerBackends.HTTP]

config :timber,
  api_key: Map.fetch!(System.get_env(), "TIMBER_API_KEY"),
  source_id: Map.fetch!(System.get_env(), "TIMBER_SOURCE_ID")

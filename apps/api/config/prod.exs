use Mix.Config

config :api, Banking.APIWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Guardian configuration
config :api, Banking.APIWeb.Guardian,
  issuer: "banking-api",
  secret_key: Map.fetch!(System.get_env(), "GUARDIAN_SECRET_KEY"),
  ttl: {2, :hour}

# Do not print debug messages in production
config :logger, level: :info

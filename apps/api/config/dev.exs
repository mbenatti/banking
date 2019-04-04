use Mix.Config

config :api, Banking.APIWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Guardian configuration
config :api, Banking.APIWeb.Guardian,
  issuer: "banking-api",
  secret_key: "35AwsI7G+xCYfDVAjiymSmo+YslwfVcUVF5ROs5a6vYdz31WyT+0CAM8Ax7GiGae",
  ttl: {30, :day}

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

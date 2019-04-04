use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, Banking.APIWeb.Endpoint,
  http: [port: 4002],
  server: false

# Guardian configuration
config :api, Banking.APIWeb.Guardian,
  issuer: "banking-api",
  secret_key: "QLafekaDQvqBGLnSDloClogTZsEoTTZQSWA3vfL217/nkQGxmoBJaXgnd8Ftd2G/"

# Print only warnings and errors during test
config :logger, level: :warn

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api,
  namespace: Banking.API

# Configures the endpoint
config :api, Banking.APIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vVtx4i5nC2K5Vg6+fOtReplha1DWVSm6xHxhsaAY2Bu558W3vw6wUO5HskkDGK4E",
  render_errors: [view: Banking.APIWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Banking.API.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :api,
  backoffice_auth: [
    username: "admin",
    password: "admin.p4ss",
    realm: "Admin Area"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

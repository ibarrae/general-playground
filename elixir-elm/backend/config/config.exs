# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :backend,
  ecto_repos: [Backend.Repo]

config :backend, Backend.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/0h0onE6X4Zvttnh0X1u9ok+GNRjXtP3jc5O7gF2Ou6MKyCRMq29GMvJpsKUlDnS",
  render_errors: [view: BackendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backend.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "7Y1YuZkT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# JWT config
config :backend, Backend.JWTSerializer,
  issuer: "ibarrae",
  secret_key: System.get_env("SECRET_KEY"),
  ttl: { 30, :days }

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :learn,
  ecto_repos: [Learn.Repo]

# Configures the endpoint
config :learn, LearnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IRSYfPH+3Zu3kVcYck+OFf5K6t/P9UTB4Tgk3xSmb+r7roTdCP6M/xGcZWY9tWBc",
  render_errors: [view: LearnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Learn.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

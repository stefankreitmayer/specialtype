# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :special_type,
  ecto_repos: [SpecialType.Repo]

# Configures the endpoint
config :special_type, SpecialType.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2+QDQnZUl1UX7+C8oJnWOuQRPh3J6yZzNrPyYM7yFKhPL1z0lceDQFOVcv4Vkfex",
  render_errors: [view: SpecialType.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SpecialType.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines, haml: PhoenixHaml.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

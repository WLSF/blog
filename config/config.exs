# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blog,
  ecto_repos: [Blog.Repo]

# Configures the endpoint
config :blog, BlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4Y4TslflRl0irUUXkUH8mKgy0Qa3I3ZIWM2tDnkbT0L051QLHHQZua8gvpFZjUqw",
  render_errors: [view: BlogWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Blog.PubSub,
  live_view: [signing_salt: "UUyBSUrT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :blog, Blog.Guardian,
  issuer: "blog",
  secret_key: "6TITixyl2J0hYtfawRTLerGlM4X03C9Y9H5KMZQtyozZb76NYEA57u7dkJPzmSr8"

config :guardian, Guardian.DB, repo: Blog.Repo, schema_name: "guardian_tokens", sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

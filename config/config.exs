# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration



config :newsly,
  ecto_repos: [Newsly.Repo]

# Configures the endpoint
# config :newsly, Newsly.Endpoint,
#   url: [host: "newslyproduction14.m28mgmyx2v.us-west-2.elasticbeanstalk.com"],
#   secret_key_base: "odZ3VPbBou3vWtzgLSp1mzBNqhmn2Zjxc5bdQLFcoa5xEaFsYG6qwbjF7b5VzSsN",
#   render_errors: [view: Newsly.ErrorView, accepts: ~w(html json)],
#   pubsub: [name: Newsly.PubSub,
#            adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :newsly, Newsly.Endpoint,
#   http: [port: 4000],
#   url: [scheme: "http", host: System.get_env("HOST"), port: 4000],
#   secret_key_base: System.get_env("SECRET_KEY_BASE"),
#   code_reloader: false,
#   # cache_static_manifest: "priv/static/manifest.json",
#   server: true



# config :ex_aws,
#   access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
#   secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
#   bucket_name: System.get_env("BUCKET_NAME"),
#   s3: [
#    scheme: "https://",
#    host: "phoenixprofilepicstoragebucket999.s3.amazonaws.com",
#    region: "us-west-2"
#   ]

# config Newsly.AssetStore,
#   access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
#   secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
#   bucket_name: System.get_env("BUCKET_NAME")
#
# config Newsly.UploadController,
#   access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
#   secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
#   bucket_name: System.get_env("BUCKET_NAME")



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"



































# # This file is responsible for configuring your application
# # and its dependencies with the aid of the Mix.Config module.
# #
# # This configuration file is loaded before any dependency and
# # is restricted to this project.
# use Mix.Config
#
# # General application configuration
# config :newsly,
#   ecto_repos: [Newsly.Repo]
#
# # Configures the endpoint
# config :newsly, Newsly.Endpoint,
#   url: [host: "localhost"],
#   secret_key_base: "odZ3VPbBou3vWtzgLSp1mzBNqhmn2Zjxc5bdQLFcoa5xEaFsYG6qwbjF7b5VzSsN",
#   render_errors: [view: Newsly.ErrorView, accepts: ~w(html json)],
#   pubsub: [name: Newsly.PubSub,
#            adapter: Phoenix.PubSub.PG2]
#
# # Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]
#
#
config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  bucket_name: {:system, "BUCKET_NAME"},
  s3: [
   scheme: "https://",
   host: "phoenixprofilepicstoragebucket999.s3.amazonaws.com",
   region: "us-west-2"
  ]
#
# # config Newsly.AssetStore,
# #   access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
# #   secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
# #   bucket_name: System.get_env("BUCKET_NAME")
# #
# # config Newsly.UploadController,
# #   access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
# #   secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
# #   bucket_name: System.get_env("BUCKET_NAME")
#
#
#
# # Import environment specific config. This must remain at the bottom
# # of this file so it overrides the configuration defined above.
# import_config "#{Mix.env}.exs"

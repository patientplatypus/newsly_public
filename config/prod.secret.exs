use Mix.Config

# use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
# config :newsly, Newsly.Endpoint,
#   secret_key_base: "CK9kgF/l6ZO+OfwztaeqlXmFNvIasYTPx9pLPE2gWD36DM0ihHg+//NKAZMojA1L"
#
# # Configure your database
# config :newsly, Newsly.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "newsly_prod",
#   pool_size: 15
# config :newsly, Newsly.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   database: "newslydb",
#   username: "patientplatypus",
#   password: "Fvnjtyb123",
#   hostname: "newsly-blah.us-west-2.elasticbeanstalk.com",
#   port: 5432,
#   pool_size: 20,
#   ssl: true

# config :ex_aws,
#   access_key_id: {:system, "AWS_ACCESS_KEY_ID"}
#   secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"},
#   bucket_name: {:system, "BUCKET_NAME"},
#   s3: [
#    scheme: "https://",
#    host: "phoenixprofilepicstoragebucket999.s3.amazonaws.com",
#    region: "us-west-2"
#   ]

config :newsly, Newsly.Repo,
  adapter: Ecto.Adapters.Postgres,
  # username: "patientplatypus",
  # password: "Fvnjty0b",
  username: System.get_env("USERNAME"),
  password: System.get_env("PASSWORD"),
  database: System.get_env("DATABASE"),
  hostname: System.get_env("DBHOST"),
  # sometimes hostname is db (like in the docker-compose method - play with this one)
  port: System.get_env("DBPORT") || 5432,
  pool_size: 10


config :newsly, Newsly.Endpoint,
  debug_errors: true,
  code_reloader: false,
  http: [port: System.get_env("PORT"), compress: true],
  url: [scheme: "http", host: System.get_env("HOST"), port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  pubsub: [adapter: Phoenix.PubSub.PG2, pool_size: 5, name: Newsly.PubSub],
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]




# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
# config :newsly, Newsly.Endpoint,
#   secret_key_base: "CK9kgF/l6ZO+OfwztaeqlXmFNvIasYTPx9pLPE2gWD36DM0ihHg+//NKAZMojA1L"
#
# # Configure your database
# config :newsly, Newsly.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "newsly_prod",
#   pool_size: 15

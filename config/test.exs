use Mix.Config

# Configure your database
config :learn, Learn.Repo,
  username: "sergio",
  password: "pg",
  database: "learn_test_ag",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :learn, LearnWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cuex, Cuex.Repo,
  database: Path.expand("../cuex_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cuex, CuexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wibYMJpMD7hYSXPAlWL4AWr8yWT3Qm0iXwJUeimjmzfn5rAYGjO7cpz8L1t2XI6U",
  server: false

config :cuex, :exchangerate, api: Cuex.Api.Mock.ExchangeRate

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

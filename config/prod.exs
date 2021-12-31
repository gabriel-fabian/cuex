import Config
config :cuex, :exchangerate,
  api: Cuex.Api.Real.ExchangeRate,
  url: "http://api.exchangeratesapi.io/v1/latest",
  api_key: System.get_env("EXCHANGERATE_API_KEY")

# Do not print debug messages in production
config :logger, level: :info

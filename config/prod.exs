import Config

config :cuex, :exchangerate,
  api: Cuex.Api.Real.ExchangeRate,
  url: "http://api.exchangeratesapi.io/v1/latest",
  # Heroku does not offer a build_time secrets manager, could fix this using Github action + AWS
  # Hardcoding here
  # TODO Remove the keys
  # api_key: "bd0de952f4ceedd0494499718f0c0a04"
  api_key: "f24f191936990dd0d2ce176d62568af2"

# Do not print debug messages in production
config :logger, level: :info

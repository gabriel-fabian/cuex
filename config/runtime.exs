import Config

# Start the phoenix server if environment is set and running in a  release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :cuex, CuexWeb.Endpoint, server: true
end

if config_env() == :prod do
  config :cuex, Cuex.Repo,
    database: Path.expand("../cuex_prod.db", Path.dirname(__ENV__.file)),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :cuex, CuexWeb.Endpoint,
    url: [scheme: "https", host: "ec2-18-230-145-172.sa-east-1.compute.amazonaws.com", port: 443],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: "JqGe+FIDQaigNflJTEjshDKQ0BeNm9GJLKgVxGuSphN91kuhfZwvQxaDC5TbsGc/"
end

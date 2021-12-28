defmodule Cuex.Repo do
  use Ecto.Repo,
    otp_app: :cuex,
    adapter: Ecto.Adapters.SQLite3
end

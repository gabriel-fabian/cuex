defmodule Cuex.Repo do
  use Ecto.Repo,
    otp_app: :cuex,
    adapter: Ecto.Adapters.SQLite3

  use Scrivener, page_size: 15
end

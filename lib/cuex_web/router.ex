defmodule CuexWeb.Router do
  use CuexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CuexWeb do
    pipe_through :api

    resources "/convert", ConversionController, only: [:create]

    scope "/conversions" do
      get("/", ConversionController, :index)
      get("/user/:user_id", ConversionController, :index)
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CuexWeb.Telemetry
    end
  end
end

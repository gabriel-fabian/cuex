defmodule Cuex.MixProject do
  use Mix.Project

  def project do
    [
      app: :cuex,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: test_coverage()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Cuex.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:httpoison, "~> 0.13.0"},
      {:jason, "~> 1.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix, "~> 1.6.5"},
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 2.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:credo, "~> 1.6", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp test_coverage do
    [
      # Ignore Phoenix default modules and views
      ignore_modules: [
        Cuex.Application,
        Cuex.DataCase,
        Cuex.Repo,
        CuexWeb,
        CuexWeb.ChangesetView,
        CuexWeb.ChangesetView,
        CuexWeb.ChannelCase,
        CuexWeb.ConnCase,
        CuexWeb.ConvertController,
        CuexWeb.ConvertView,
        CuexWeb.Endpoint,
        CuexWeb.ErrorHelpers,
        CuexWeb.ErrorView,
        CuexWeb.FallbackController,
        CuexWeb.RequestView,
        CuexWeb.Router,
        CuexWeb.Router.Helpers,
        CuexWeb.Telemetry
      ]
    ]
  end
end

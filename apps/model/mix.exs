defmodule Banking.Model.MixProject do
  use Mix.Project

  def project do
    [
      app: :model,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Banking.Model.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:decimal, "~> 1.7"},
      {:comeonin, "~> 5.1"},
      {:argon2_elixir, "~> 2.0"},
      {:enum_type, "~> 1.0"},
      {:timex, "~> 3.5"},
      # Tests
      {:ex_machina, "~> 2.2", only: :test},
      {:faker, "~> 0.12.0", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

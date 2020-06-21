defmodule GCPSecretManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :gcp_secret_manager,
      description: "Google Cloud Platform Secret Manager elixir API",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      maintainers: ["Dipendra Singh"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/sdipendra/ecto-gcd"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GCP.SecretManager.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.2.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

defmodule LinkPreview.Mixfile do
  use Mix.Project

  @version "1.0.3"

  def project do
    [
      aliases: aliases(),
      app: :link_preview,
      deps: deps(),
      description: description(),
      docs: [
        extras: ["README.md", "CHANGELOG.md"]
      ],
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: "https://appunite.com",
      name: "Link Preview",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      source_url: "https://github.com/appunite/link_preview",
      test_coverage: [
        tool: ExCoveralls
      ],
      version: @version
    ]
  end

  defp description do
    """
    LinkPreview is a package that tries to receive meta information from given http(s) address.
    Generated page struct includes website title, description, images and more.
    """
  end

  defp package do
    [
      files: ["lib", "config", "mix.exs", "README.md", "CHANGELOG.md"],
      maintainers: ["Tobiasz Małecki", "Karol Wojtaszek"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/appunite/link_preview",
        "Sponsor" => "https://appunite.com"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:floki, "~> 0.36.2"},
      {:tesla, "~> 1.4"},
      {:briefly, "~> 0.5.1"},
      {:html_entities, "~> 0.5", optional: true},
      {:mogrify, "~> 0.9.3", optional: true},

      # testing/docs
      {:excoveralls, "~> 0.18.1", only: :test},
      {:ex_doc, "~> 0.34.0", only: :dev},
      {:httparrot, "~> 1.3", only: :test},
      {:mimic, "~> 1.7", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["test --exclude excluded"]
    ]
  end
end

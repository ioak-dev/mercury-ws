defmodule Appnamehere.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Appnamehere.Repo,
      # Start the Telemetry supervisor
      AppnamehereWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Appnamehere.PubSub},
      # Start the Endpoint (http/https)
      AppnamehereWeb.Endpoint
      # Start a worker by calling: Appnamehere.Worker.start_link(arg)
      # {Appnamehere.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Appnamehere.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AppnamehereWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

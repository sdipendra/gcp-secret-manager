defmodule GCP.SecretManager.Application do
  @moduledoc false

  use Application

  require Logger

  def start(type, args) do
    Logger.debug("start called!")
    Logger.debug("type: #{inspect type}")
    Logger.debug("args: #{inspect args}")

    children = [
      {GCP.SecretManager, name: GCP.SecretManager}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
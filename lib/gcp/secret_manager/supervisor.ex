defmodule GCP.SecretManager.Supervisor do
  @moduledoc false

  use Supervisor

  require Logger

  def start_link(opts) do
    Logger.debug("start called!")
    Logger.debug("opts: #{inspect opts}")

    name = opts[:name] || raise ArgumentError, "the :name option is required when starting GCP.SecretManager"
    supervisor_name = Module.concat(name, "Supervisor")

    Supervisor.start_link(__MODULE__, opts, name: supervisor_name)
  end

  def init(opts) do
    Logger.debug("init called!")
    Logger.debug("opts: #{inspect opts}")

    # todo: Maybe use name as registry_name
    name = opts[:name]
    registry_name = Module.concat(name, "Registry")

    # todo: Purpose of id in child_spec, understand complete child_spec
    registry_opts = [
      keys: :unique,
      name: registry_name,
      meta: []
    ]

    children = [
      {Registry, registry_opts},
      {GCP.SecretManager.Worker, Keyword.put(opts, :name, {:via, Registry, {registry_name, "worker"}})}
    ]
    Supervisor.init(children, strategy: :rest_for_one)
  end
end
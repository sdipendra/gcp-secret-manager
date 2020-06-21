defmodule GCP.SecretManager.Worker do
  @moduledoc false

  use GenServer

  alias GCP.SecretManager
  alias GCP.Metadata

  require Logger

  @start_state %{}

  def start_link(opts) do
    Logger.debug("start_link called!")
    Logger.debug("opts: #{inspect opts}")
#    opts = Keyword.put(opts, :name, :worker)
    GenServer.start_link(__MODULE__, @start_state, opts)
  end

  def init(state) do
    Logger.debug("init called!")
    Logger.debug("state: #{inspect state}")

    {:ok, project_id} = Metadata.Api.get("/computeMetadata/v1/project/project-id")
    {:ok, %{project_id: project_id}}
  end

  defp build_uri(project_id, key, version, action)
       when(
             is_binary(project_id) and
             is_binary(key) and
             is_binary(version)
             ) do
    "/v1/projects/" <> project_id <> "/secrets/" <> key <> "/versions/" <> version <> ":" <> action
  end

  def handle_call({:access, key, version}, _from, state) do
    Logger.debug("handle_call called!")
    Logger.debug("key: #{inspect key}")
    Logger.debug("version: #{inspect version}")
    Logger.debug("_from: #{inspect _from}")
    Logger.debug("state: #{inspect state}")

    with uri <- build_uri(state.project_id, key, version, "access"),
         {:ok, %{body: raw_body}} <- SecretManager.Api.get(uri),
         {:ok, %{"payload" => %{"data" => encoded_data}}} <- Jason.decode(raw_body),
         {:ok, data} <- Base.decode64(encoded_data) do
      {:reply, {:ok, data}, state}
    else
      _ -> {:reply, {:error, "Unknown Error!"}, state}
    end
  end

  def handle_cast(msg, state) do
    Logger.debug("handle_cast called!")
    Logger.debug("msg: #{inspect msg}")
    Logger.debug("state: #{inspect state}")
    {:noreply, state}
  end
end
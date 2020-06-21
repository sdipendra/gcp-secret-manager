defmodule GCP.SecretManager do
  @moduledoc false

  # todo: See if required
  require Logger

  defdelegate child_spec(opts), to: GCP.SecretManager.Supervisor

  # todo: Add elixir guard statements like when is etc in function calls
  def access(mod, key)  do
    access(mod, key, "latest")
  end

  def access(mod, key, version)  do
    with {:ok, pid} <- get_pid(mod, "worker"),
         {:ok, response} <- GenServer.call(pid, {:access, key, version}) do
      {:ok, response}
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Unknown error occured!"}
    end
  end

  defp get_pid(mod, proc_name) do
    registry = Module.concat(mod, "Registry")
    case Registry.lookup(registry, proc_name) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, "Key not found in registry!"}
      _ -> {:error, "Unknown error occured while retrieving key from registry"}
    end
  end
end
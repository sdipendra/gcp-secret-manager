defmodule GCP.SecretManager.Api.Url do
  @moduledoc false

  @enforce_keys [:service_endpoint, :project_id, :key, :version]
  defstruct [:service_endpoint, :project_id, :key, :version]

end

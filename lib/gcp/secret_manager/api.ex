defmodule GCP.SecretManager.Api do
  @moduledoc false

  use HTTPoison.Base

  require Logger

  @service_endpoint "https://secretmanager.googleapis.com"

  def process_url(uri) do
    @service_endpoint <> uri
  end

  def process_request_headers(headers) do
    with {:ok, raw_body} <- GCP.Metadata.Api.get("/computeMetadata/v1/instance/service-accounts/default/token"),
         {:ok, %{
           "access_token" => access_token,
           "expires_in" => expires_in,
           "token_type" => token_type
         }} <- Jason.decode(raw_body) do
      headers = [{:"Authorization", "#{token_type} #{access_token}"} | headers]
      Logger.debug("headers: #{inspect headers}")
      headers
    else
      _ -> {:error, "Error while processing request headers"}
    end
  end

end

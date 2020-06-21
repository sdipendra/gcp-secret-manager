defmodule GCP.Metadata.Api do
  @moduledoc false

  use HTTPoison.Base

  alias HTTPoison.Response

  @service_endpoint "http://metadata.google.internal"

  def process_url(uri) do
    @service_endpoint <> uri
  end

  def process_request_headers(headers) do
    [{:"Metadata-Flavor", "Google"} | headers]
  end

  def process_response(%Response{} = response) do
    response.body
  end

end

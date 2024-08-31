defmodule Khronos.Sec.Client.Data do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://data.sec.gov" <> url
  end

  def process_response_body(body) do
    Jason.decode!(body)
  end

  def process_request_headers(_headers) do
    # Necessary for bypassing SEC security/rate limiting blockers
    [
      "User-Agent": "khronos@canary-data.com"
    ]
  end
end

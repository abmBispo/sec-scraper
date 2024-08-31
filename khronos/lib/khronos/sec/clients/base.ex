defmodule Khronos.Sec.Client.Base do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://www.sec.gov" <> url
  end

  def process_response_body(body) do
    decompressed = :zlib.gunzip(body)

    decompressed
    |> Jason.decode()
    |> case do
      {:ok, decoded_body} -> decoded_body
      {:error, _} -> decompressed
    end
  end

  def process_request_headers(_headers) do
    [
      Host: "www.sec.gov",
      "Accept-Encoding": "gzip",
      "User-Agent": "khronos@canary-data.com"
    ]
  end
end

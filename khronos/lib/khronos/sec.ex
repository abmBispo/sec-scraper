defmodule Khronos.Sec do
  alias Khronos.Sec.Client.Base, as: BaseClient
  alias Khronos.Sec.Client.Data, as: DataClient
  alias Khronos.Sec.Entities.Company
  alias Khronos.Sec.Entities.Submissions
  alias Khronos.Sec.Entities.Trade

  def companies_data do
    with %{body: %{"data" => companies_data}} <-
           BaseClient.get!("/files/company_tickers_exchange.json") do
      companies =
        for company <- companies_data do
          Company.initialize(company)
        end

      {:ok, %{companies: companies}}
    end
  end

  def company_submissions(cik) do
    id = put_leading_zeros(cik)

    with %{status_code: 200, body: data} <- DataClient.get!("/submissions/CIK#{id}.json") do
      {:ok, %{submissions: Submissions.initialize(data)}}
    end
  end

  def company_trades(cik, accession_number, primary_document) do
    with %{status_code: 200, body: data} <-
           BaseClient.get!("/Archives/edgar/data/#{cik}/#{accession_number}/#{primary_document}") do
      {:ok, Trade.initialize(data, accession_number)}
    end
  end

  defp put_leading_zeros(cik) when is_binary(cik),
    do: String.pad_leading(cik, 10, "0")

  defp put_leading_zeros(cik) when is_integer(cik) do
    cik
    |> Integer.to_string()
    |> String.pad_leading(10, "0")
  end
end

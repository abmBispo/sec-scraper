defmodule Khronos.Sec.Entities.Trade do
  defstruct [
    :person_name,
    :accession_number,
    :amount_of_shares,
    :is_director,
    :is_officer,
    :transaction_date
  ]

  import SweetXml

  @spec initialize(data :: map(), accession_number :: String.t()) :: %__MODULE__{}
  def initialize(xml_data, accession_number) do
    amount_of_derivative_shares = amount_of_derivative_shares(xml_data)
    amount_of_non_derivative_shares = amount_of_non_derivative_shares(xml_data)

    %__MODULE__{
      accession_number: accession_number,
      person_name: xpath(xml_data, person_name_xpath()),
      amount_of_shares: amount_of_derivative_shares + amount_of_non_derivative_shares,
      is_director: xpath(xml_data, owner_relationship_xpath("isDirector")),
      is_officer: xpath(xml_data, owner_relationship_xpath("isOfficer")),
      transaction_date: xpath(xml_data, period_of_report_xpath())
    }
  end

  defp period_of_report_xpath do
    ~x"//ownershipDocument/periodOfReport/text()"s
  end

  defp person_name_xpath do
    ~x"//ownershipDocument/reportingOwner/reportingOwnerId/rptOwnerName/text()"s
  end

  defp amount_of_non_derivative_shares(xml) do
    xml
    |> xpath(
      ~x"//ownershipDocument/nonDerivativeTable/nonDerivativeTransaction/transactionAmounts/transactionShares/value/text()"l
    )
    |> Enum.reduce(0, fn amount, acc ->
      amount = parse_amount(amount) || 0
      amount + acc
    end)
  end

  defp amount_of_derivative_shares(xml) do
    xml
    |> xpath(
      ~x"//ownershipDocument/derivativeTable/derivativeTransaction/transactionAmounts/transactionShares/value/text()"l
    )
    |> Enum.reduce(0, fn amount, acc ->
      amount = parse_amount(amount) || 0
      amount + acc
    end)
  end

  defp owner_relationship_xpath(type) do
    ~x"//ownershipDocument/reportingOwner/reportingOwnerRelationship/#{type}/text()"s
  end

  defp parse_amount(amount) do
    if is_list(amount), do: String.to_integer("#{amount}"), else: amount
  end
end

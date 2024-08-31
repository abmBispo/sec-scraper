defmodule Khronos.Sec.Entities.Submissions do
  defstruct [:cik, :accession_number, :primary_document]

  @spec initialize(data :: map()) :: %__MODULE__{}
  def initialize(data) do
    list = build_info(data["filings"]["recent"])

    list
    |> Enum.map(fn info ->
      %__MODULE__{
        cik: data["cik"],
        accession_number: info[:accession_number],
        primary_document: info[:primary_document]
      }
    end)
  end

  defp build_info(info) do
    merge_lists(info["accessionNumber"], info["primaryDocument"], info["form"])
  end

  defp parse_accession_numbers(number) do
    String.replace(number, "-", "")
  end

  defp parse_primary_document(code) do
    code
    |> String.split("/")
    |> List.last()
  end

  defp merge_lists(accesion_numbers, primary_documents, forms),
    do: merge_lists(accesion_numbers, primary_documents, forms, [])

  defp merge_lists([], _, _, merge),
    do: merge

  defp merge_lists(_, [], _, merge),
    do: merge

  defp merge_lists(
         [accession_number | accession_numbers_tail],
         [primary_document | primary_documents_tail],
         ["4" = _form | forms_tail],
         merge
       ) do
    new_merge = [
      %{
        accession_number: parse_accession_numbers(accession_number),
        primary_document: parse_primary_document(primary_document)
      }
      | merge
    ]

    merge_lists(accession_numbers_tail, primary_documents_tail, forms_tail, new_merge)
  end

  defp merge_lists(
         [_ | accession_numbers_tail],
         [_ | primary_documents_tail],
         [_any_other_form_type | forms_tail],
         merge
       ) do
    merge_lists(accession_numbers_tail, primary_documents_tail, forms_tail, merge)
  end
end

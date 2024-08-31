defmodule Khronos.Commands.BatchUpsertCompanySubmissions do
  use Khronos.Command

  import Khronos.Utils.Structs, only: [to_map: 1]

  @primary_key false
  embedded_schema do
    embeds_many :submissions, Submission, primary_key: false do
      field(:cik, :string)
      field(:accession_number, :string)
      field(:primary_document, :string)
    end
  end

  def validate(params) do
    %__MODULE__{}
    |> cast(params, [])
    |> cast_embed(:submissions, with: &submission_changeset/2)
  end

  @fields [:accession_number, :primary_document, :cik]
  def submission_changeset(company, params) do
    company
    |> cast(to_map(params), @fields)
  end
end

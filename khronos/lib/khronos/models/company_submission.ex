defmodule Khronos.Models.CompanySubmission do
  @derive {Jason.Encoder, except: [:__meta__, :company, :company_trade]}

  use Ecto.Schema
  import Ecto.Changeset
  alias Khronos.Models.Company
  alias Khronos.Models.CompanyTrade

  schema "company_submissions" do
    field(:cik, :string)
    field(:accession_number, :string)
    field(:primary_document, :string)
    field(:synchronized, :boolean)
    has_one(:company_trade, CompanyTrade)
    belongs_to(:company, Company)
  end

  @fields [:cik, :accession_number, :primary_document, :synchronized, :company_id]

  def changeset(company_submission, attrs) do
    company_submission
    |> cast(attrs, @fields)
  end
end

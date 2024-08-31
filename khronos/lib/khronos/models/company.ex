defmodule Khronos.Models.Company do
  @derive {Jason.Encoder, except: [:__meta__, :company_submissions]}

  use Ecto.Schema
  import Ecto.Changeset
  alias Khronos.Models.CompanySubmission

  schema "companies" do
    field(:cik, :string)
    field(:name, :string)
    field(:ticker, :string)
    field(:exchange, :string)
    field(:market_cap, :integer)
    has_many(:company_submissions, CompanySubmission)
    has_many(:trades, through: [:company_submissions, :company_trades])
  end

  @fields [:cik, :name, :ticker, :exchange]

  def changeset(company, attrs) do
    company
    |> cast(attrs, @fields)
  end
end

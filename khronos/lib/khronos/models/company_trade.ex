defmodule Khronos.Models.CompanyTrade do
  @derive {Jason.Encoder, except: [:__meta__, :company_submission, :company_submission_id]}

  use Ecto.Schema
  import Ecto.Changeset
  alias Khronos.Models.CompanySubmission

  schema "company_trades" do
    field(:person_name, :string)
    field(:owner_relationship, Ecto.Enum, values: [:director, :officer, :other])
    field(:amount_of_shares, :integer)
    field(:transaction_date, :date)
    field(:market_cap_ratio, :float, virtual: true)
    belongs_to(:company_submission, CompanySubmission)
  end

  @fields [
    :person_name,
    :amount_of_shares,
    :owner_relationship,
    :company_submission_id,
    :transaction_date
  ]

  def changeset(trade, attrs) do
    trade
    |> cast(attrs, @fields)
  end
end

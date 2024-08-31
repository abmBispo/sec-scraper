defmodule Khronos.Commands.BatchUpsertCompanies do
  use Khronos.Command

  import Khronos.Utils.Structs, only: [to_map: 1]

  @primary_key false
  embedded_schema do
    field :async, :boolean, default: false

    embeds_many :companies, Company, primary_key: false do
      field(:cik, :string)
      field(:name, :string)
      field(:ticker, :string)
      field(:exchange, :string)
    end
  end

  def validate(params) do
    %__MODULE__{}
    |> cast(params, [])
    |> cast_embed(:companies, with: &company_changeset/2)
  end

  @fields [:cik, :name, :ticker, :exchange]
  def company_changeset(company, params) do
    company
    |> cast(to_map(params), @fields)
  end
end

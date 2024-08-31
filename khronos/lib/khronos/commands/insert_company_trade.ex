defmodule Khronos.Commands.InsertCompanyTrade do
  use Khronos.Command
  import Khronos.Utils.Structs, only: [to_map: 1]

  @primary_key false
  embedded_schema do
    field(:accession_number, :string)
    field(:person_name, :string)
    field(:amount_of_shares, :integer)
    field(:is_director, :boolean)
    field(:is_officer, :boolean)
    field(:transaction_date, :date)
  end

  @fields [
    :accession_number,
    :person_name,
    :amount_of_shares,
    :is_director,
    :is_officer,
    :transaction_date
  ]

  def validate(params) do
    params = to_map(params)
    params = %{params | is_director: if(params[:is_director] == "1", do: true, else: false)}
    params = %{params | is_officer: if(params[:is_officer] == "1", do: true, else: false)}

    %__MODULE__{}
    |> cast(params, @fields)
  end
end

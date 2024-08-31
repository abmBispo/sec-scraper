defmodule Khronos.Commands.GetCompanyTrades do
  use Khronos.Command

  @primary_key false
  embedded_schema do
    field(:ticker, :string)
  end

  def validate(params) do
    %__MODULE__{}
    |> cast(params, [:ticker])
  end
end

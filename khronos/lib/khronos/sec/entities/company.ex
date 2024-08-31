defmodule Khronos.Sec.Entities.Company do
  defstruct [:cik, :name, :ticker, :exchange]

  @spec initialize(data :: map()) :: %__MODULE__{}
  def initialize([cik, name, ticker, exchange]) do
    %__MODULE__{
      cik: to_string(cik),
      name: name,
      ticker: ticker,
      exchange: exchange
    }
  end
end

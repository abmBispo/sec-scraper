defmodule Khronos.Workers.SynchronizeCompanies do
  use Oban.Worker, unique: [period: 60, fields: [:args]]

  def schedule do
    __MODULE__.new(%{})
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(_) do
    Khronos.synchronize_companies([])
  end
end

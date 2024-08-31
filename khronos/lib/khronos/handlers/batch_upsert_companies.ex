defmodule Khronos.Handlers.BatchUpsertCompanies do
  import Khronos.Utils.Structs, only: [to_map: 1]
  alias Ecto.Multi
  alias Khronos.Models.Company
  alias Khronos.Repo

  def handle(command) do
    Multi.new()
    |> Multi.put(:command, command)
    |> Multi.all(:existing_companies, Company)
    |> Multi.insert_all(:insert_all, Company, &insert_all_companies/1)
    |> Repo.transaction()
  end

  defp insert_all_companies(%{command: command, existing_companies: existing_companies}) do
    existing_companies_mapping =
      existing_companies
      |> Enum.map(&{&1.cik, true})
      |> Map.new()

    command
    |> to_map()
    |> get_in([:companies])
    |> Enum.filter(&if get_in(existing_companies_mapping, [&1.cik]), do: false, else: true)
    # Mocking market cap value
    |> Enum.map(&Map.put(&1, :market_cap, Enum.random(10_000_000..99_999_999)))
  end
end

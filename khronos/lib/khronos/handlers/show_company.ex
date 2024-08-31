defmodule Khronos.Handlers.ShowCompany do
  import Khronos.Utils.Structs, only: [to_map: 1]
  import Ecto.Query
  alias Ecto.Multi
  alias Khronos.Models.Company
  alias Khronos.Repo

  def handle(command) do
    Multi.new()
    |> Multi.put(:command, to_map(command))
    |> Multi.one(:company, &company_query/1)
    |> Multi.run(:check_presence, &check_presence/2)
    |> Repo.transaction()
  end

  defp company_query(%{command: command}) do
    Company
    |> where([c], c.ticker == ^command.ticker)
    |> limit(1)
  end

  defp check_presence(_repo, %{company: nil}),
    do: {:error, :not_found}

  defp check_presence(_repo, %{company: _}),
    do: {:ok, true}
end

defmodule Khronos.Handlers.GetCompanyTrades do
  import Khronos.Utils.Structs, only: [to_map: 1]
  import Ecto.Query
  alias Ecto.Multi
  alias Khronos.Models.Company
  alias Khronos.Models.CompanySubmission
  alias Khronos.Models.CompanyTrade
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
    |> join(:inner, [c], s in CompanySubmission, on: c.id == s.company_id)
    |> join(:inner, [_c, s], t in CompanyTrade, on: s.id == t.company_submission_id)
    |> where([c], c.ticker == ^command.ticker)
    |> order_by([_c, _s, t], desc: t.transaction_date)
    |> preload([_c, _s, t], trades: t)
  end

  defp check_presence(_repo, %{company: nil}),
    do: {:error, :not_found}

  defp check_presence(_repo, %{company: _}),
    do: {:ok, true}
end

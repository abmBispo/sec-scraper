defmodule Khronos.Handlers.InsertCompanyTrade do
  import Khronos.Utils.Structs, only: [to_map: 1]
  import Ecto.Query
  alias Ecto.Multi
  alias Khronos.Models.CompanySubmission
  alias Khronos.Models.CompanyTrade
  alias Khronos.Repo

  def handle(command) do
    Multi.new()
    |> Multi.put(:command, to_map(command))
    |> Multi.one(:submission, &submission_query/1)
    |> Multi.one(:existing_trade, &existing_trade_query/1)
    |> Multi.insert(:trade, &insert_trade/1)
    |> Multi.update(:update_submission, &update_submission/1)
    |> Repo.transaction()
  end

  defp submission_query(%{command: command}) do
    CompanySubmission
    |> where([s], s.accession_number == ^command.accession_number)
    |> limit(1)
  end

  defp existing_trade_query(%{submission: submission}) do
    CompanyTrade
    |> where([t], t.company_submission_id == ^submission.id)
    |> limit(1)
  end

  defp insert_trade(%{existing_trade: %CompanyTrade{}}),
    do: {:error, :existing_trade_found}

  defp insert_trade(%{command: command, submission: submission}) do
    command =
      command
      |> Map.put(:company_submission_id, submission.id)
      |> case do
        %{is_director: true} = map -> Map.put(map, :owner_relationship, :director)
        %{is_officer: true} = map -> Map.put(map, :owner_relationship, :officer)
        map -> Map.put(map, :owner_relationship, :other)
      end

    CompanyTrade.changeset(%CompanyTrade{}, command)
  end

  defp update_submission(%{submission: submission}) do
    CompanySubmission.changeset(submission, %{synchronized: true})
  end
end

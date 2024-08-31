defmodule Khronos.Handlers.BatchUpsertCompanySubmissions do
  import Khronos.Utils.Structs, only: [to_map: 1]
  import Ecto.Query
  alias Ecto.Multi
  alias Khronos.Models.Company
  alias Khronos.Models.CompanySubmission
  alias Khronos.Repo

  def handle(command) do
    Multi.new()
    |> Multi.put(:command, to_map(command))
    |> Multi.one(:company, &company_query/1)
    |> Multi.all(:existing_submissions, &submissions_query/1)
    |> Multi.insert_all(:insert_all, CompanySubmission, &insert_all_submissions/1)
    |> Repo.transaction()
  end

  defp insert_all_submissions(%{
         command: command,
         company: company,
         existing_submissions: existing_submissions
       }) do
    existing_submissions_mapping =
      existing_submissions
      |> Enum.map(&{&1.accession_number, true})
      |> Map.new()

    command
    |> get_in([:submissions])
    |> Enum.filter(
      &if get_in(existing_submissions_mapping, [&1.accession_number]), do: false, else: true
    )
    |> Enum.map(&Map.put(&1, :company_id, company.id))
  end

  defp company_query(%{command: %{submissions: [submission | _]}}) do
    Company
    |> where([c], c.cik == ^submission.cik)
    |> limit(1)
  end

  defp submissions_query(%{command: command}) do
    accession_numbers = Enum.map(command.submissions, & &1.accession_number)
    where(CompanySubmission, [s], s.accession_number in ^accession_numbers)
  end
end

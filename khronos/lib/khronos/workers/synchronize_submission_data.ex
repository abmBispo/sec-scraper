defmodule Khronos.Workers.SynchronizeSubmissionData do
  use Oban.Worker, unique: [period: 600, fields: [:args]]
  import Ecto.Query
  alias Khronos.Models.CompanySubmission
  alias Khronos.Repo
  alias Khronos.Workers.SynchronizeTrades

  def schedule(cik) do
    %{cik: to_string(cik)}
    |> __MODULE__.new()
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"cik" => cik}}) do
    submissions_chunks =
      CompanySubmission
      |> where([s], s.cik == ^cik and not s.synchronized)
      |> Repo.all()
      |> Enum.chunk_every(10)

    if submissions_chunks == [] do
      :ok
    else
      submissions_chunks
      |> Enum.with_index()
      |> Enum.each(fn {submissions, idx} ->
        Enum.each(submissions, fn submission ->
          SynchronizeTrades.schedule(
            submission.cik,
            submission.accession_number,
            submission.primary_document,
            # 5 second guarantee to avoid hitting rate-limit
            5 * idx
          )
        end)
      end)

      :ok
    end
  end
end

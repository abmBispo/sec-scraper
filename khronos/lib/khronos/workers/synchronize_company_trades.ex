defmodule Khronos.Workers.SynchronizeTrades do
  use Oban.Worker, unique: [period: 60, fields: [:args]]

  def schedule(cik, accession_number, primary_document, schedule_in) do
    %{
      cik: to_string(cik),
      accession_number: accession_number,
      primary_document: primary_document
    }
    |> __MODULE__.new(schedule_in: schedule_in)
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "cik" => cik,
          "accession_number" => accession_number,
          "primary_document" => primary_document
        }
      }) do
    Khronos.insert_trades(cik, accession_number, primary_document)
  end
end

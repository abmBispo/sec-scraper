defmodule Khronos.Repo.Migrations.AddCompanySubmissions do
  use Ecto.Migration

  def change do
    create table(:company_submissions) do
      add :cik, :string
      add(:company_id, references(:companies))
      add :accession_number, :string
      add :primary_document, :string
      add :synchronized, :boolean, null: false, default: false
    end
  end
end

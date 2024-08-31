defmodule Khronos.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:cik, :string)
      add(:name, :string)
      add(:ticker, :string)
      add(:exchange, :string)
    end
  end
end

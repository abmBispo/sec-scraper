defmodule Khronos.Repo.Migrations.AddMarketCapToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add(:market_cap, :integer)
    end
  end
end

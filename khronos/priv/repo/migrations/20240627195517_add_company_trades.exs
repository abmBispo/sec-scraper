defmodule Khronos.Repo.Migrations.AddCompanyTrades do
  use Ecto.Migration

  def up do
    execute(
      "CREATE TYPE company_trade_owner_relationship AS ENUM ('director', 'officer', 'other')"
    )

    create table(:company_trades) do
      add(:person_name, :string)
      add(:owner_relationship, :company_trade_owner_relationship, null: false, default: "other")
      add(:amount_of_shares, :integer)
      add(:transaction_date, :date)
      add(:company_submission_id, references(:company_submissions))
    end
  end

  def down do
    drop table(:company_trades)

    execute("DROP TYPE company_trade_owner_relationship")
  end
end

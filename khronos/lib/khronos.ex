defmodule Khronos do
  @moduledoc """
  Khronos keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Khronos.Commands
  alias Khronos.Handlers
  alias Khronos.Sec
  alias Khronos.Workers.SynchronizeCompanies
  alias Khronos.Workers.SynchronizeSubmissionData

  def synchronize_companies(async: true) do
    SynchronizeCompanies.schedule()
  end

  def synchronize_companies(_opts) do
    with {:ok, companies_data} <- Sec.companies_data(),
         {:ok, command} <- Commands.BatchUpsertCompanies.create(companies_data) do
      Handlers.BatchUpsertCompanies.handle(command)
    end
  end

  def synchronize_company_submissions(cik) do
    with {:ok, companies_data} <- Sec.company_submissions(cik),
         {:ok, command} <- Commands.BatchUpsertCompanySubmissions.create(companies_data),
         {:ok, _} <- Handlers.BatchUpsertCompanySubmissions.handle(command) do
      SynchronizeSubmissionData.schedule(cik)
    end
  end

  def insert_trades(cik, accession_number, primary_document) do
    with {:ok, trade_data} <- Sec.company_trades(cik, accession_number, primary_document),
         {:ok, command} <- Commands.InsertCompanyTrade.create(trade_data) do
      Handlers.InsertCompanyTrade.handle(command)
    end
  end

  def show_company(params) do
    with {:ok, command} <- Commands.ShowCompany.create(params) do
      Handlers.ShowCompany.handle(command)
    end
  end

  def get_company_trades(params) do
    with {:ok, command} <- Commands.GetCompanyTrades.create(params) do
      Handlers.GetCompanyTrades.handle(command)
    end
  end
end

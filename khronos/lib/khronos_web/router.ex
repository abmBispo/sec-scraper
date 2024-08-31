defmodule KhronosWeb.Router do
  use KhronosWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KhronosWeb do
    pipe_through :api

    get "/companies/:ticker", CompanyController, :show
    get "/companies/:ticker/trades", CompanyController, :trades
  end

  scope "/admin", KhronosWeb do
    pipe_through :api

    post "/import_companies", AdminController, :import_companies
    post "/import_company_trades/:cik", AdminController, :import_company_trades
  end
end

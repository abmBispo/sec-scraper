defmodule KhronosWeb.CompanyController do
  use KhronosWeb, :controller
  alias KhronosWeb.Views.CompanyJSON

  def show(conn, params) do
    with {:ok, %{company: company}} <- Khronos.show_company(params) do
      conn
      |> put_view(json: CompanyJSON)
      |> render(:show, company: company)
    end
  end

  def trades(conn, params) do
    with {:ok, %{company: company}} <- Khronos.get_company_trades(params) do
      conn
      |> put_view(json: CompanyJSON)
      |> render(:trades, company: company)
    end
  end
end

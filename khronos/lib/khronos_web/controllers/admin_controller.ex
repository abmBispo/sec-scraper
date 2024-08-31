defmodule KhronosWeb.AdminController do
  use KhronosWeb, :controller
  alias KhronosWeb.Views.AdminJSON

  def import_companies(conn, _) do
    with {:ok, _} <- Khronos.synchronize_companies(async: true) do
      conn
      |> put_view(json: AdminJSON)
      |> render(:import_companies)
    end
  end

  def import_company_trades(conn, params) do
    with {:ok, _} <- Khronos.synchronize_company_submissions(params["cik"]) do
      conn
      |> put_view(json: AdminJSON)
      |> render(:import_companies)
    end
  end
end

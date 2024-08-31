defmodule FallbackController do
  use Phoenix.Controller
  alias KhronosWeb.ErrorJSON

  def call(conn, {:error, _step, :not_found, _multi}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, step, reason, _multi}) do
    conn
    |> put_status(500)
    |> put_view(ErrorJSON)
    |> render(:"500", step: step, reason: reason)
  end
end

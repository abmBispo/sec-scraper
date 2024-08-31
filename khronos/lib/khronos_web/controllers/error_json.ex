defmodule KhronosWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """
  def render("500.json", %{step: step, reason: reason}) do
    %{
      errors: %{
        message: "Internal Server Error",
        details: %{
          step: step,
          reason: reason
        }
      }
    }
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

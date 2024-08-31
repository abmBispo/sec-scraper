defmodule KhronosWeb.Views.CompanyJSON do
  def show(%{company: company}) do
    company
    |> Map.delete(:trades)
    |> Map.delete(:__struct__)
    |> Map.delete(:__meta__)
    |> Map.delete(:company_submissions)
  end

  def trades(%{company: company}) do
    %{
      company
      | trades:
          Enum.map(company.trades, fn trade ->
            ratio =
              (trade.amount_of_shares / company.market_cap * 100)
              |> Float.round(8)

            Map.put(trade, :market_cap_ratio, ratio)
          end)
    }
  end
end

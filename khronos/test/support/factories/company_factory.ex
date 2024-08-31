defmodule Khronos.CompanyFactory do
  defmacro __using__(_opts) do
    quote do
      def company_factory do
        %Khronos.Models.Company{
          cik: Faker.random_between(10_000, 99_999) |> to_string(),
          name: Faker.Company.name(),
          ticker: Faker.Finance.Stock.ticker(),
          exchange: Enum.random(["NASDAQ", "NYSE"])
        }
      end
    end
  end
end

defmodule Khronos.CompanySubmissionFactory do
  defmacro __using__(_opts) do
    quote do
      def company_submission_factory do
        cik = Faker.random_between(10_000, 99_999) |> to_string()

        %Khronos.Models.CompanySubmission{
          cik: cik,
          accession_number: Faker.random_between(10_000, 99_999) |> to_string(),
          primary_document: (Faker.random_between(10_000, 99_999) |> to_string()) <> ".xml",
          synchronized: Enum.random([false, true]),
          company_id: insert(:company, cik: cik).id
        }
      end
    end
  end
end

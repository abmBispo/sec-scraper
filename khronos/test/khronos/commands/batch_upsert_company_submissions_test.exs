defmodule Khronos.Commands.BatchUpsertCompaniesTest do
  use Khronos.DataCase, async: true
  alias Khronos.Commands.BatchUpsertCompanySubmissions

  describe "create/2" do
    test "successfully builds a command" do
      params = params_for(:company_submission)
      data = %{companies: [params]}

      assert {:ok, %BatchUpsertCompanySubmissions{}} = BatchUpsertCompanySubmissions.create(data)
    end
  end
end

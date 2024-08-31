defmodule Khronos.Commands.BatchUpsertCompanySubmissionsTest do
  use Khronos.DataCase, async: true
  alias Khronos.Commands.BatchUpsertCompanies

  describe "create/2" do
    test "successfully builds a command" do
      params = params_for(:company)
      data = %{companies: [params]}

      assert {:ok, %BatchUpsertCompanies{}} = BatchUpsertCompanies.create(data)
    end
  end
end

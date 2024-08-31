defmodule Khronos.Handlers.BatchUpsertCompaniesTest do
  use Khronos.DataCase, async: true
  alias Khronos.Commands.BatchUpsertCompanies, as: Command
  alias Khronos.Handlers.BatchUpsertCompanies, as: Handler
  import Khronos.Utils.Structs, only: [to_map: 1]

  describe "create/2" do
    test "successfully handle 3 companies insertion in batch" do
      data = %{companies: [params_for(:company), params_for(:company), params_for(:company)]}

      assert {:ok, command} = Command.create(data)
      assert {:ok, %{insert_all: {3, nil}}} = Handler.handle(command)
    end

    test "successfully handle 2 companies insertion in batch and ignore a existing one" do
      existing_company = insert(:company)
      data = %{companies: [to_map(existing_company), params_for(:company), params_for(:company)]}

      assert {:ok, command} = Command.create(data)

      assert {:ok, %{insert_all: {2, nil}, existing_companies: [^existing_company]}} =
               Handler.handle(command)
    end
  end
end

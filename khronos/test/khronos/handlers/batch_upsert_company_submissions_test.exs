defmodule Khronos.Handlers.BatchUpsertCompanySubmissionsTest do
  use Khronos.DataCase, async: true
  alias Khronos.Commands.BatchUpsertCompanySubmissions, as: Command
  alias Khronos.Handlers.BatchUpsertCompanySubmissions, as: Handler
  import Khronos.Utils.Structs, only: [to_map: 1]

  describe "create/2" do
    test "successfully handle 3 submissions insertion in batch" do
      data = %{
        submissions: [
          params_for(:company_submission),
          params_for(:company_submission),
          params_for(:company_submission)
        ]
      }

      assert {:ok, command} = Command.create(data)
      assert {:ok, %{insert_all: {3, nil}}} = Handler.handle(command)
    end

    test "successfully handle 2 submissions insertion in batch and ignore a existing one" do
      existing_submission = insert(:company_submission)

      data = %{
        submissions: [
          to_map(existing_submission),
          params_for(:company_submission),
          params_for(:company_submission)
        ]
      }

      assert {:ok, command} = Command.create(data)

      assert {:ok, %{insert_all: {2, nil}, existing_submissions: [^existing_submission]}} =
               Handler.handle(command)
    end
  end
end

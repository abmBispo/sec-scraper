defmodule Khronos.Models.CompanySubmissionTest do
  use Khronos.DataCase, async: true
  alias Khronos.Models.CompanySubmission

  describe "changeset/2" do
    test "successfully builds a changeset" do
      params = params_for(:company_submission)

      assert %Ecto.Changeset{valid?: true} =
               CompanySubmission.changeset(%CompanySubmission{}, params)
    end
  end
end

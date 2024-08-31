defmodule Khronos.Models.CompanyTest do
  use Khronos.DataCase, async: true
  alias Khronos.Models.Company

  describe "changeset/2" do
    test "successfully builds a changeset" do
      params = params_for(:company)
      assert %Ecto.Changeset{valid?: true} = Company.changeset(%Company{}, params)
    end
  end
end

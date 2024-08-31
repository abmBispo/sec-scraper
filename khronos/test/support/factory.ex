defmodule Khronos.Factory do
  use ExMachina.Ecto, repo: Khronos.Repo
  use Khronos.CompanyFactory
  use Khronos.CompanySubmissionFactory
end

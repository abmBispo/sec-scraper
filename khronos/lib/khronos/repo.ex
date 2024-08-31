defmodule Khronos.Repo do
  use Ecto.Repo,
    otp_app: :khronos,
    adapter: Ecto.Adapters.Postgres
end

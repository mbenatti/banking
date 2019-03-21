defmodule Banking.Model.Repo do
  use Ecto.Repo,
    otp_app: :model,
    adapter: Ecto.Adapters.Postgres
end

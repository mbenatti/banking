defmodule Banking.Model.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :model,
    adapter: Ecto.Adapters.Postgres
end

defmodule Banking.Model.Repo.Migrations.AddPasswordOnAccountsTable do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :password, :string
    end
  end
end

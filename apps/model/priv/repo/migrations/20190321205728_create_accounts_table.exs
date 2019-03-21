defmodule Banking.Model.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def up do
    create table(:accounts) do
      add(:name, :string, null: false)
      add(:email, :string, null: false)

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end

  def down do
    drop table(:accounts)
  end
end

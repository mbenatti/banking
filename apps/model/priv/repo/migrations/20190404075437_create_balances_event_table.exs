defmodule Banking.Model.Repo.Migrations.CreateBalancesEventTable do
  use Ecto.Migration

  def change do
    create table(:balances_event) do
      add :quantity_moved, :decimal, null: false, precision: 19, scale: 4
      add :balance, :decimal, null: false, precision: 19, scale: 4
      add :type, :string

      add :account_id, references(:accounts), null: false
      add :parent_id, references(:balances_event)

      timestamps()
    end

    create index(:balances_event, [:account_id])
  end
end

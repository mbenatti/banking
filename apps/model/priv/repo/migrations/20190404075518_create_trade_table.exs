defmodule Banking.Model.Repo.Migrations.CreateTradeTable do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :account_id, references(:accounts), null: false
      add :transfer_account_id, references(:accounts)
      add :balance_event_id, references(:balances_event), null: false

      timestamps()
    end

    create index(:trades, [:account_id])
  end
end

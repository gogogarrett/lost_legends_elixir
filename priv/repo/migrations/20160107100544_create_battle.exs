defmodule LostLegends.Repo.Migrations.CreateBattle do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :monster_id, references(:monsters, on_delete: :nothing)

      timestamps
    end
    create index(:battles, [:monster_id])

  end
end

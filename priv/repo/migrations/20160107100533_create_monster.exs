defmodule LostLegends.Repo.Migrations.CreateMonster do
  use Ecto.Migration

  def change do
    create table(:monsters) do
      add :name, :string
      add :desc, :text
      add :health, :integer

      timestamps
    end

  end
end

defmodule Timemanager.Repo.Migrations.AddTeammm do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:teams, [:name])


    execute "INSERT INTO teams (name, inserted_at, updated_at) VALUES ('No team', NOW(), NOW()) ON CONFLICT (name) DO NOTHING;"
  end
end

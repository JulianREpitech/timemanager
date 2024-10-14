defmodule Timemanager.Repo.Migrations.Addcolumnworkintime do
  use Ecto.Migration

  def change do
    alter table(:working_times) do
      add :working_type, :string
      add :repetitive, :map, null: true
    end

  end
end

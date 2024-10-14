defmodule Timemanager.Repo.Migrations.AddTeamIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :team_id, references(:teams, on_delete: :nilify_all), default: 1
    end
  end
end

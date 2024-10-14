defmodule Timemanager.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false

      timestamps()
    end

    # Insert default roles (1 - Employee, 2 - Manager)
    execute "INSERT INTO roles (name, inserted_at, updated_at) VALUES ('Employee', NOW(), NOW())"
    execute "INSERT INTO roles (name, inserted_at, updated_at) VALUES ('Manager', NOW(), NOW())"
    execute "INSERT INTO roles (name, inserted_at, updated_at) VALUES ('GeneralManager', NOW(), NOW())"
  end
end

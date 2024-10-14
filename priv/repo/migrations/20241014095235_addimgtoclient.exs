defmodule Timemanager.Repo.Migrations.Addimgtoclient do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :img_url, :string
    end
  end
end

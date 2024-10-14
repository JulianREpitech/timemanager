defmodule Timemanager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email, :img_url]}
  schema "users" do
    field :username, :string
    field :email, :string
    belongs_to :role, Timemanager.Role
    belongs_to :team, Timemanager.Accounts.Team, foreign_key: :team_id
    field :img_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role_id, :team_id])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$/, message: "must be a valid email address")
    |> unique_constraint(:email)
    |> put_default_role()
    |> put_default_team()
    |> assoc_constraint(:role)
    |> assoc_constraint(:team)
  end

  # Helper function to set the default role to 1 (Employee)
  defp put_default_role(changeset) do
    case get_field(changeset, :role_id) do
      nil -> put_change(changeset, :role_id, 1)
      _ -> changeset
    end
  end
  defp put_default_team(changeset) do
    case get_field(changeset, :team_id) do
      nil -> put_change(changeset, :team_id, 1)
      _ -> changeset
    end
  end
end

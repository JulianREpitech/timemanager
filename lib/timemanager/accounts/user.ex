defmodule Timemanager.Accounts.User do
  alias TimemanagerWeb.Guardian
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    belongs_to :role, Timemanager.Role
    belongs_to :team, Timemanager.Accounts.Team, foreign_key: :team_id

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
    |> hash_password()
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


  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :hashed_password, Guardian.hash_password(password))
    end
  end
end

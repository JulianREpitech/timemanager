defmodule Timemanager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Accounts.User
  alias Timemanager.Accounts.Team
  alias Timemanager.Role

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    User
    |> build_query(params) # Call the build_query function
    |> Timemanager.Repo.all()
    |> Timemanager.Repo.preload(:role)
    |> Timemanager.Repo.preload(:team)
  end

  defp build_query(query, params) do
    query
    |> add_email_filter(params["email"])
    |> add_username_filter(params["username"])
  end

  defp add_email_filter(query, nil), do: query
  defp add_email_filter(query, email) do
    from u in query, where: u.email == ^email
  end

  defp add_username_filter(query, nil), do: query
  defp add_username_filter(query, username) do
    from u in query, where: u.username == ^username
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:role) |> Repo.preload(:team)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # Chercher ou créer l'équipe "No team"
    default_team = Repo.get_by(Timemanager.Accounts.Team, name: "No team") ||
                   Repo.insert!(%Timemanager.Accounts.Team{name: "No team"})

    # Ajouter l'équipe par défaut "No team" si aucune équipe n'est spécifiée
    attrs = Map.put_new(attrs, "team_id", default_team.id)

    # Ajouter le rôle par défaut "Employé" (role_id = 1) si aucun rôle n'est spécifié
    attrs = Map.put_new(attrs, "role_id", 1)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end



  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
  # Rôles
  def list_roles do
    Repo.all(Role)
  end

  def get_role(id) do
    Repo.get(Role, id)
    |> Repo.preload(users: [:team])
  end

  # Équipes
  def list_teams do
    Repo.all(Team)
  end


  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  def get_team_with_users(id) do
    Team
    |> Repo.get(id)
    |> Repo.preload(users: [:role, :team])
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end


end

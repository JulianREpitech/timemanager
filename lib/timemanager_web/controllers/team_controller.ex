defmodule TimemanagerWeb.TeamController do
  use TimemanagerWeb, :controller

  alias Timemanager.Accounts
  alias Timemanager.Accounts.Team

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    teams = Accounts.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    case Accounts.create_team(team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team created successfully.")
        |> put_status(:created)
        |> json(%{data: team})

      {:error, %Ecto.Changeset{errors: errors}} ->
        error_messages = Enum.map(errors, fn {field, {message, _}} -> %{field: field, message: message} end)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error_messages})
    end
  end


  def show(conn, %{"id" => id}) do
    team = Accounts.get_team_with_users(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Accounts.get_team_with_users(id)

    with {:ok, %Team{} = team} <- Accounts.update_team(team, team_params) do
      team = Accounts.get_team_with_users(team.id)
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team_with_users(id)

    with {:ok, %Team{}} <- Accounts.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end

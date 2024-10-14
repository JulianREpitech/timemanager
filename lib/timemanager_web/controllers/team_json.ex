defmodule TimemanagerWeb.TeamJSON do
  alias Timemanager.Accounts.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: dataShow(team)}
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
    }
  end
  defp dataShow(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      users: user_data(team.users)
    }
  end

  defp user_data(nil), do: nil
  defp user_data(users) do
    for user <- users do
      %{
        id: user.id,
        username: user.username,
        email: user.email,
        role: role_data(user.role),
        team: team_data(user.team)
      }
    end
  end

  defp role_data(nil), do: nil
  defp role_data(role) do
    %{
      id: role.id,
      name: role.name
    }
  end

  defp team_data(nil), do: nil
  defp team_data(team) do
    %{
      id: team.id,
      name: team.name
    }
  end
end

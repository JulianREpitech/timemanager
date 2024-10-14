defmodule TimemanagerWeb.RoleJSON do
  alias Timemanager.Role

  @doc """
  Renders a list of roles.
  """
  def index(%{roles: roles}) do
    %{data: for(role <- roles, do: data(role))}
  end

  @doc """
  Renders a single role.
  """
  def show(%{role: role}) do
    %{data: dataShow(role)}
  end

  defp data(%Role{} = role) do
    %{
      id: role.id,
      name: role.name,
    }
  end

  defp dataShow(%Role{} = role) do
    %{
      id: role.id,
      name: role.name,
      users: user_data(role.users)
    }
  end

  defp user_data(nil), do: nil
  defp user_data(users) do
    for user <- users do
      %{
        id: user.id,
        username: user.username,
        email: user.email,
        team: team_data(user.team)
      }
    end
  end

  defp team_data(nil), do: nil
  defp team_data(team) do
    %{
      id: team.id,
      name: team.name
    }
  end
end

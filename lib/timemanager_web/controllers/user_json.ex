defmodule TimemanagerWeb.UserJSON do
  alias Timemanager.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: role_data(user.role),
      team: team_data(user.team)
    }
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

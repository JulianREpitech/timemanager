defmodule TimemanagerWeb.RoleController do
  use TimemanagerWeb, :controller
  alias Timemanager.Accounts
  # alias Timemanager.Accounts.Role

  action_fallback TimemanagerWeb.FallbackController

  # GET /api/roles
  def index(conn, _params) do
    roles = Accounts.list_roles()
    render(conn, :index, roles: roles)
  end

  # GET /api/roles/:id
  def show(conn, %{"id" => id}) do
    role = Accounts.get_role(id)
    render(conn, :show, role: role)
  end

  # PUT /api/roles/:id
  # def update(conn, %{"id" => id, "role" => role_params}) do
  #   case Accounts.update_role(id, role_params) do
  #     {:ok, role} -> json(conn, role)
  #     {:error, changeset} -> json(conn, changeset)
  #   end
  # end
end

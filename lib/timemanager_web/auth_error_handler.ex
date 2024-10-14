defmodule TimemanagerWeb.AuthErrorHandler do
  import Plug.Conn
  use TimemanagerWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Unauthorized"})
  end
end

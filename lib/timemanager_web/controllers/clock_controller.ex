defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.WorkTimes
  alias Timemanager.WorkTimes.Clock

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    clocks = WorkTimes.list_clocks(user_id)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- WorkTimes.create_clock(user_id, clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, user_id, clock.id))
      |> render(:show, clock: clock)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    clock = WorkTimes.get_clock!(user_id, id)
    render(conn, :show, clock: clock)
  end

  # Helper function to format changeset errors
  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  # Helper function to translate error messages
  defp translate_error(msg) do
    msg
  end
end

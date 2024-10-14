defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias Timemanager.WorkTimes
  alias Timemanager.WorkTimes.WorkingTime

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id} = params) do
    start_date = Map.get(params, "start")
    end_date = Map.get(params, "end")

    {start_dt, start_error} = parse_date(start_date)
    {end_dt, end_error} = parse_date(end_date)

    if start_error or end_error do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid date format. Please use ISO8601."})
      |> halt()
    end

    working_times = WorkTimes.list_working_times_for_user(user_id, start_dt, end_dt)

    render(conn, :index, working_times: working_times)
  end

  defp parse_date(nil), do: {nil, false}
  defp parse_date(date_string) do
    case DateTime.from_iso8601(date_string) do
      {:ok, date_time, _} -> {date_time, false}
      _ -> {nil, true}
    end
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    working_time_params = Enum.map(working_time_params, fn {k, v} -> {to_string(k), v} end) |> Enum.into(%{})

    with {:ok, %WorkingTime{} = working_time} <- WorkTimes.create_working_time(user_id, working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{working_time.id}")
      |> render(:show, working_time: working_time)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    working_time = WorkTimes.get_working_time_for_user!(user_id, id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end

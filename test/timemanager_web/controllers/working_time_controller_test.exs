defmodule TimemanagerWeb.WorkingTimeControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.WorkTimesFixtures
  import Timemanager.AccountsFixtures

  alias Timemanager.WorkTimes.WorkingTime

  @create_attrs %{
    start: "2024-10-08T09:00:00Z",
    end: "2024-10-08T17:00:00Z"
  }
  @update_attrs %{
    start: "2024-10-09 15:07:00Z",
    end: "2024-10-09 17:07:00Z"
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    user = user_fixture()
    conn = put_req_header(conn, "accept", "application/json")
    %{}
    {:ok, conn: conn, user: user,user_id: user.id}
  end

  describe "index" do
    test "lists all working_times", %{conn: conn, user_id: user_id} do
      conn = get(conn, ~p"/api/workingtime/#{user_id}")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/workingtime/#{user.id}", working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtime/#{user.id}/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-08T17:00:00Z", # Updated to match the create_attrs
               "start" => "2024-10-08T09:00:00Z"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update working_time" do
    setup [:create_working_time_fixture]

    test "renders working_time when data is valid", %{conn: conn, user_id: user_id, working_time: %WorkingTime{id: id} = working_time} do
      conn = put(conn, ~p"/api/workingtime/#{working_time}", working_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtime/#{user_id}/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-09T17:07:00Z", # Updated to match the update_attrs
               "start" => "2024-10-09T15:07:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      conn = put(conn, ~p"/api/workingtime/#{working_time}", working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time_fixture]

    test "deletes chosen working_time", %{conn: conn, user_id: user_id, working_time: working_time} do
      conn = delete(conn, ~p"/api/workingtime/#{working_time}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtime/#{user_id}/#{working_time}")
      end
    end
  end

  defp create_working_time_fixture(%{user_id: user_id}) do
    working_time = working_time_fixture(user_id)
    %{working_time: working_time}
  end
end

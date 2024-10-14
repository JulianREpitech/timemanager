defmodule TimemanagerWeb.ClockControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.AccountsFixtures

  @create_attrs %{
    status: true,
    time: ~U[2024-10-08T09:00:00Z]
  }

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, conn: put_req_header(conn, "accept", "application/json"),user_id: user.id}
  end

  describe "index" do
    test "lists all clocks", %{conn: conn, user_id: user_id} do
      conn = get(conn, ~p"/api/clocks/#{user_id}")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn, user_id: user_id} do
      conn = post(conn, ~p"/api/clocks/#{user_id}", clock: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{user_id}/#{id}")

      # Convert the time from the response to DateTime for comparison
      assert %{
               "id" => ^id,
               "status" => true,
               "time" => time_string
             } = json_response(conn, 200)["data"]

      # Parse the time_string into a DateTime for comparison
      assert DateTime.from_iso8601(time_string) == {:ok, ~U[2024-10-08T09:00:00Z], 0}
    end
  end


end

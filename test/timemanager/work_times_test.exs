defmodule Timemanager.WorkTimesTest do
  use Timemanager.DataCase

  alias Timemanager.WorkTimes

  describe "working_times" do
    alias Timemanager.WorkTimes.WorkingTime

    import Timemanager.WorkTimesFixtures
    import Timemanager.AccountsFixtures

    @invalid_attrs %{start: nil, end: nil}

    setup do
      user = user_fixture()
      %{user_id: user.id}
    end

    test "list_working_times_for_user/0 returns all working_times for a user", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      assert WorkTimes.list_working_times_for_user(user_id) == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      assert WorkTimes.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time", %{user_id: user_id} do
      valid_attrs = %{start: ~U[2024-10-08T09:00:00Z], end: ~U[2024-10-08T09:00:00Z]}
      valid_attrs = for {k, v} <- valid_attrs,
      do: {to_string(k), v}, into: %{}

      assert {:ok, %WorkingTime{} = working_time} = WorkTimes.create_working_time(user_id, valid_attrs)
      assert working_time.start == ~U[2024-10-08T09:00:00Z]
      assert working_time.end == ~U[2024-10-08T09:00:00Z]
      assert working_time.user_id == user_id
    end

    test "create_working_time/1 with invalid data returns error changeset", %{user_id: user_id} do
      invalid_attrs = for {k, v} <- @invalid_attrs,
      do: {to_string(k), v}, into: %{}
      assert {:error, %Ecto.Changeset{}} = WorkTimes.create_working_time(user_id, invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      update_attrs = %{start: ~U[2024-10-07 15:07:00Z], end: ~U[2024-10-07 15:07:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = WorkTimes.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2024-10-07 15:07:00Z]
      assert working_time.end == ~U[2024-10-07 15:07:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      assert {:error, %Ecto.Changeset{}} = WorkTimes.update_working_time(working_time, @invalid_attrs)
      assert working_time == WorkTimes.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      assert {:ok, %WorkingTime{}} = WorkTimes.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkTimes.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset", %{user_id: user_id} do
      working_time = working_time_fixture(user_id)
      assert %Ecto.Changeset{} = WorkTimes.change_working_time(working_time)
    end
  end

  describe "clocks" do
    alias Timemanager.WorkTimes.Clock

    import Timemanager.WorkTimesFixtures
    import Timemanager.AccountsFixtures

    @invalid_attrs %{status: nil, time: nil}

    setup do
      user = user_fixture()
      %{user_id: user.id}
    end

    test "list_clocks/0 returns all clocks for a user", %{user_id: user_id} do
      clock = clock_fixture(user_id)
      assert WorkTimes.list_clocks(user_id) == [clock]
    end

    test "get_clock!/1 returns the clock with given id", %{user_id: user_id} do
      clock = clock_fixture(user_id)
      assert WorkTimes.get_clock!(user_id, clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock", %{user_id: user_id} do
      valid_attrs = %{status: true, time: ~U[2024-10-08T09:00:00Z]}
      valid_attrs = for {k, v} <- valid_attrs,
      do: {to_string(k), v}, into: %{}

      assert {:ok, %Clock{} = clock} = WorkTimes.create_clock(user_id, valid_attrs)
      assert clock.status == true
      assert clock.time == ~U[2024-10-08T09:00:00Z]
      assert clock.user_id == user_id
    end

    test "create_clock/1 with invalid data returns error changeset", %{user_id: user_id} do
      invalid_attrs = for {k, v} <- @invalid_attrs,
      do: {to_string(k), v}, into: %{}
      assert {:error, %Ecto.Changeset{}} = WorkTimes.create_clock(user_id, invalid_attrs)
    end
  end
end

defmodule Timemanager.WorkTimesFixtures do
  alias Timemanager.WorkTimes
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.WorkTimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(user_id, attrs \\ %{}) do
    valid_attrs = %{
      start: ~U[2024-10-06 15:07:00Z],
      end: ~U[2024-10-06 15:07:00Z],
      user_id: user_id
    }

    # Merge attrs into valid_attrs without conversion
    attrs = Map.merge(valid_attrs, attrs)
    attrs = for {k, v} <- attrs,
    do: {to_string(k), v}, into: %{}

    {:ok, working_time} = WorkTimes.create_working_time(user_id, attrs)
    working_time
  end


  @doc """
  Generate a clock.
  """
  def clock_fixture(user_id, attrs \\ %{}) do
    valid_attrs = %{
      status: true,
      time: ~U[2024-10-08 09:00:00Z],
      user_id: user_id
    }

    attrs = Enum.into(attrs, valid_attrs)
    attrs = for {k, v} <- attrs,
    do: {to_string(k), v}, into: %{}

    {:ok, clock} = WorkTimes.create_clock(user_id, attrs)
    clock
  end


end

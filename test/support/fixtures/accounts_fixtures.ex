defmodule Timemanager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Accounts` context.
  """

  def unique_user_email, do: "email#{System.unique_integer()}@example.com"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "Wow username",
        email: unique_user_email()
      })
      |> Timemanager.Accounts.create_user()

    user
  end
end

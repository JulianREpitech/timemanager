defmodule Timemanager.AccountsTest do
  use Timemanager.DataCase

  alias Timemanager.Accounts

  describe "users" do
    alias Timemanager.Accounts.User

    import Timemanager.AccountsFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/1 returns all users when no filter is applied" do
      user1 = user_fixture(username: "user1", email: "user1@example.com")
      user2 = user_fixture(username: "user2", email: "user2@example.com")

      assert Accounts.list_users(%{}) == [user1, user2]
    end

    test "list_users/1 returns users filtered by username" do
      user1 = user_fixture(username: "user1", email: "user1@example.com")
      user2 = user_fixture(username: "user2", email: "user2@example.com")

      assert Accounts.list_users(%{"username" => "user1"}) == [user1]
      assert Accounts.list_users(%{"username" => "user2"}) == [user2]
      assert Accounts.list_users(%{"username" => "nonexistent"}) == []
    end

    test "list_users/1 returns users filtered by email" do
      user1 = user_fixture(username: "user1", email: "user1@example.com")
      user2 = user_fixture(username: "user2", email: "user2@example.com")

      assert Accounts.list_users(%{"email" => "user1@example.com"}) == [user1]
      assert Accounts.list_users(%{"email" => "user2@example.com"}) == [user2]
      assert Accounts.list_users(%{"email" => "nonexistent@example.com"}) == []
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "Wow username", email: "email@email.com"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == "Wow username"
      assert user.email == "email@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", email: "some.updated@email.com"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "some.updated@email.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

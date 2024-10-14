defmodule TimemanagerWeb.UserController do
alias TimemanagerWeb.Guardian
  use TimemanagerWeb, :controller

  alias Timemanager.Accounts
  alias Timemanager.Accounts.User

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, params) do
    IO.puts(Guardian.hash_password("test"))
    users = Accounts.list_users(params)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_status(:created)
        |> json(%{data: user})

      {:error, %Ecto.Changeset{errors: errors}} ->
        error_messages = Enum.map(errors, fn {field, {message, _}} -> %{field: field, message: message} end)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error_messages})
    end
  end


  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      user = Accounts.get_user!(user.id)
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end


  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, token, _claims} ->
        conn
        |> json(%{token: token})
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end
end

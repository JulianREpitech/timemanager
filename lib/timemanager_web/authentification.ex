defmodule TimemanagerWeb.Guardian do
  use Guardian, otp_app: :timemanager

  alias Timemanager.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def hash_password(password) when is_binary(password) do
    :crypto.hash(:sha256, password)
    |> Base.encode64()
  end

  def hash_password(_), do: {:error, "Invalid password"}
end

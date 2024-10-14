defmodule Timemanager.WorkTimes.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end,:user_id, :inserted_at, :updated_at, :working_type, :repetitive]}
  schema "working_times" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, Timemanager.Accounts.User
    field :working_type, :string
    field :repetitive, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :working_type, :repetitive])
    |> validate_required([:start, :end, :user_id, :working_type])
    # |> validate_end_after_start()
    |> foreign_key_constraint(:user_id)
  end

  # defp validate_end_after_start(changeset) do
  #   start = get_field(changeset, :start)
  #   end_time = get_field(changeset, :end)

  #   if start && end_time && DateTime.compare(start, end_time) != :lt do
  #     add_error(changeset, :end, "must be after start time")
  #   else
  #     changeset
  #   end
  # end
end

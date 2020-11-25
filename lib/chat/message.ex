defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :name, :string
    field :room, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message, :room])
    |> update_change(:name, &String.trim/1)
    |> update_change(:room, &String.trim/1)
    |> validate_required([:name, :message, :room])
  end

  def get_messages(limit \\ 20) do
    Chat.Message |> Chat.Repo.all(limit: limit)
  end
end

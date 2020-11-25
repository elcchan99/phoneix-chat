defmodule Chat do
  @moduledoc """
  Chat keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import Ecto.Query, warn: false
  alias Chat.Repo
  alias Chat.Message

  def list_messages_by_room(room \\ "lobby") do
    qry =
      from m in Message,
        where: m.room == ^room,
        order_by: [asc: m.inserted_at]

    Repo.all(qry)
  end

  def list_names_by_room(room \\ "lobby") do
    qry =
      from m in Message,
        where: m.room == ^room,
        order_by: [asc: m.name],
        distinct: true,
        select: m.name

    Repo.all(qry) |> IO.inspect(label: "unqiue names")
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end

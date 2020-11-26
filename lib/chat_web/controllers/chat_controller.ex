defmodule ChatWeb.ChatController do
  use ChatWeb, :controller

  plug ChatWeb.Plugs.Auth

  def show(conn, %{"id" => room}) do
    messages = Chat.list_messages_by_room(room)

    render(conn, "show.html", room: room, messages: messages)
  end
end

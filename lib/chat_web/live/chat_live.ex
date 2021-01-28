defmodule ChatWeb.ChatLive do
  use Phoenix.LiveView
  # alias ChatWeb.Chats

  defp topic(id), do: "chat:#{id}"

  def render(assigns) do
    ChatWeb.ChatLiveView.render("show.html", assigns)
  end

  def mount(
        _params,
        %{"room" => room, "current_user" => current_user},
        socket
      ) do
    chat_messages = Chat.list_messages_by_room(room)

    {:ok,
     assign(socket,
       room: room,
       messages: chat_messages,
       changeset: Chat.Message.changeset(%Chat.Message{}, %{}),
       current_user: current_user
     )}
  end

  def handle_event("new_message", %{"message" => message_params}, socket) do
    message = Chat.create_message(message_params)
    room = message.room
    chat_messages = Chat.list_messages_by_room(room)

    ChatWeb.Endpoint.broadcast_from(self(), topic(room), "message", %{
      messages: chat_messages
    })

    {:noreply,
     assign(socket,
       messages: chat_messages,
       changeset: Chat.Message.changeset(%Chat.Message{}, %{})
     )}
  end
end

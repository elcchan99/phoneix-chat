defmodule ChatWeb.ChatChannel do
  use ChatWeb, :channel
  alias Chat

  @impl true
  def join("chat:" <> _room, payload, socket) do
    if authorized?(socket, payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    "chat:" <> room = socket.topic

    payload
    |> Map.merge(%{"room" => room})
    |> Chat.create_message()

    broadcast(socket, "shout", payload)
    send(self(), :after_join)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    socket.topic |> IO.inspect(label: "names")
    "chat:" <> room = socket.topic

    # Chat.list_messages_by_room(room)
    # |> Enum.each(fn msg ->
    #   push(socket, "shout", %{
    #     name: msg.name,
    #     message: msg.message
    #   })
    # end)

    online_status =
      Chat.list_names_by_room(room)
      |> Enum.map(fn name -> {name, Enum.random(["on", "off"])} end)
      |> Map.new()

    push(socket, "online-status-update", online_status)

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, %{"token" => token}) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
      {:ok, user} ->
        !!user

      {:error, _reason} ->
        false
    end
  end
end

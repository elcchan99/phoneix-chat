defmodule ChatWeb.ChatChannel do
  use ChatWeb, :channel
  alias Chat
  alias ChatWeb.Presence

  @impl true
  def join("chat:" <> _room, payload, socket) do
    case authorized?(socket, payload) do
      {:ok, user} ->
        send(self(), :after_join)
        {:ok, socket |> assign(:user_id, user)}

      {:no, _} ->
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

    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second))
      })

    push(socket, "presence_state", Presence.list(socket))

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
        {:ok, user}

      {:error, _reason} ->
        {:no, nil}
    end
  end
end

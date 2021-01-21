defmodule ChatWeb.ChatLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h1> Room </h1>
    <pre><%= @room %></pre>
    <h1> Historical messages </h1>
    <pre>
      <%= for message <- @messages do %>
        <%= message.message %>
      <% end %>
    </pre>
    <h1> Current user </h1>
    <pre><%= @current_user %></pre>
    """
  end

  def mount(_params, %{"room" => room, "current_user" => current_user}, socket) do
    chat_messages = Chat.list_messages_by_room(room)

    {:ok,
     assign(socket,
       room: room,
       messages: chat_messages,
       current_user: current_user
     )}
  end
end

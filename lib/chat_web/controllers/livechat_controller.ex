defmodule ChatWeb.LiveChatController do
  use ChatWeb, :controller
  import Phoenix.LiveView.Controller

  plug ChatWeb.Plugs.Auth

  def show(conn, %{"id" => room}) do
    live_render(
      conn,
      ChatWeb.ChatLive,
      session: %{
        "room" => room,
        "current_user" => conn.assigns.current_user
      }
    )
  end
end

defmodule ChatWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias ChatWeb.Helpers.Auth

  def init(_params) do
  end

  def call(conn, _params) do
    if Auth.signed_in?(conn) do
      current_user = Auth.current_user(conn)

      conn
      |> assign(:current_user, current_user)
      |> assign(:user_signed_in?, true)
    else
      conn
      |> assign(:current_user, nil)
      |> assign(:user_signed_in?, false)
    end
  end
end

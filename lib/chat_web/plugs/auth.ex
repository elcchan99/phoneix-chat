defmodule ChatWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias ChatWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "You need to sign in before continuing.")
      |> redirect(to: Helpers.session_path(conn, :index))
      |> halt()
    end
  end
end

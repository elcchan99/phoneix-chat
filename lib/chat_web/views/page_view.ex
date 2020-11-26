defmodule ChatWeb.PageView do
  use ChatWeb, :view

  def csrf_token(conn) do
    Plug.Conn.get_session(conn, :csrf_token)
  end
end

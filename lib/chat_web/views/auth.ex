defmodule ChatWeb.Helpers.Auth do
  @spec signed_in?(Plug.Conn.t()) :: boolean
  def signed_in?(conn) do
    !!current_user(conn)
  end

  @spec current_user(Plug.Conn.t()) :: any
  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user_id)
  end
end

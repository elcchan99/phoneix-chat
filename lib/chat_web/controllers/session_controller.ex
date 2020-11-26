defmodule ChatWeb.SessionController do
  use ChatWeb, :controller

  plug ChatWeb.Plugs.Auth when action in [:delete]

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def create(conn, %{"name" => user}) do
    conn
    |> put_session(:current_user_id, user)
    |> put_flash(:info, "Signed in successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, _param) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

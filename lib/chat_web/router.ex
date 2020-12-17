defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker, excluded_paths: ["/login", ~r(/admin.*)], history_size: 5
    plug ChatWeb.Plugs.SetCurrentUser
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/login", SessionController, only: [:index, :create]
    delete "/logout", SessionController, :delete
    resources "/chat", ChatController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ChatWeb.Telemetry
    end
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns.current_user do
      token = Phoenix.Token.sign(conn, "user socket", current_user)

      conn
      |> assign(:user_token, token)
    else
      conn
    end
  end
end

defmodule SampleAppWeb.Router do
  use SampleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampleAppWeb do
    pipe_through :browser

    get "/", StaticPageController, :home, as: :root
    get "/static_pages/home", StaticPageController, :home
    get "/static_pages/help", StaticPageController, :help
    get "/static_pages/about", StaticPageController, :about
    get "/static_pages/contact", StaticPageController, :contact
    get "/signup", UserController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    post "/users", UserController, :create
  end

  scope "/", SampleAppWeb do
    pipe_through [:browser, :permit_logged_in_user]

    resources "/users", UserController, except: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleAppWeb do
  #   pipe_through :api
  # end

  def assign_current_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
      user_id ->
        conn
        |> assign(:current_user, SampleApp.Accounts.get_user!(user_id))
    end
  end

  def permit_logged_in_user(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> redirect(to: SampleAppWeb.Router.Helpers.session_path(conn, :new))
        |> halt()
      _ ->
        conn
    end
  end
end

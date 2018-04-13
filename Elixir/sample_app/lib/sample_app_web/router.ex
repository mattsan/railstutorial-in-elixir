defmodule SampleAppWeb.Router do
  use SampleAppWeb, :router

  import SampleAppWeb.Auth

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
  end

  scope "/", SampleAppWeb do
    pipe_through :browser

    get "/signup", UserController, :new, as: :signup
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    post "/users", UserController, :create
  end

  scope "/", SampleAppWeb do
    pipe_through [:browser, :permit_logged_in_user]

    resources "/users", UserController, only: [:index, :show]
    resources "/microposts", MicropostController, only: [:create, :delete]
  end

  scope "/", SampleAppWeb do
    pipe_through [:browser, :permit_logged_in_user, :correct_user]

    resources "/users", UserController, only: [:edit, :update]
  end

  scope "/", SampleAppWeb do
    pipe_through [:browser, :permit_logged_in_user, :admin_user]

    resources "/users", UserController, only: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleAppWeb do
  #   pipe_through :api
  # end
end

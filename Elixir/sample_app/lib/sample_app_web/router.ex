defmodule SampleAppWeb.Router do
  use SampleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampleAppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", StaticPageController, :home, as: :root
    get "/static_pages/home", StaticPageController, :home
    get "/static_pages/help", StaticPageController, :help
    get "/static_pages/about", StaticPageController, :about
    get "/static_pages/contact", StaticPageController, :contact
    get "/signup", UserController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleAppWeb do
  #   pipe_through :api
  # end
end

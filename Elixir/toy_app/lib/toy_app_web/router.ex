defmodule ToyAppWeb.Router do
  use ToyAppWeb, :router

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

  scope "/", ToyAppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", UserController, :index
    resources "/users", UserController
    resources "/microposts", MicropostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ToyAppWeb do
  #   pipe_through :api
  # end
end

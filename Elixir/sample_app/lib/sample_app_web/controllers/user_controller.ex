defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller

  def new(conn, _) do
    conn
    |> assign(:title, "Sign up")
    |> render(:new)
  end
end

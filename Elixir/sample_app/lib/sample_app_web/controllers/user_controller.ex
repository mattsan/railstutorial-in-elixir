defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller

  def new(conn, _) do
    conn
    |> render(:new)
  end
end

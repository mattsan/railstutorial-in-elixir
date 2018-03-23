defmodule SampleAppWeb.StaticPageController do
  use SampleAppWeb, :controller

  def home(conn, _) do
    conn
    |> render(:home)
  end

  def help(conn, _) do
    conn
    |> assign(:title, "Help")
    |> render(:help)
  end

  def about(conn, _) do
    conn
    |> assign(:title, "About")
    |> render(:about)
  end
end

defmodule SampleAppWeb.StaticPageController do
  use SampleAppWeb, :controller

  def home(conn, _) do
    conn
    |> render(:home)
  end

  def help(conn, _) do
    conn
    |> render(:help)
  end

  def about(conn, _) do
    conn
    |> render(:about)
  end

  def contact(conn, _) do
    conn
    |> render(:contact)
  end
end

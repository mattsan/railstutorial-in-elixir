defmodule SampleAppWeb.StaticPageController do
  use SampleAppWeb, :controller

  alias SampleApp.Repo
  alias SampleApp.Articles.Micropost
  alias SampleAppWeb.Auth

  import Ecto.Query

  def home(conn, params) do
    assigns =
      if Auth.logged_in?(conn) do
        feed_items =
          conn
          |> current_uer()
          |> Ecto.assoc(:microposts)
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(params)

        [
          changeset: Micropost.changeset(%Micropost{}, %{}),
          feed_items: feed_items
        ]
      else
        []
      end

    conn
    |> render(:home, assigns)
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

  defp current_uer(conn) do
    conn.assigns[:current_user]
  end
end

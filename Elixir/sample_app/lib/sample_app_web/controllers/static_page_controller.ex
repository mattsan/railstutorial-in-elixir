defmodule SampleAppWeb.StaticPageController do
  use SampleAppWeb, :controller

  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost
  alias SampleAppWeb.Auth

  def home(conn, params) do
    assigns =
      if Auth.logged_in?(conn) do
        feed_items = Articles.list_microposts_paginated(params, current_user(conn))

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

  defp current_user(conn) do
    conn.assigns[:current_user]
  end
end

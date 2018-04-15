defmodule SampleAppWeb.MicropostController do
  use SampleAppWeb, :controller

  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost

  alias SampleApp.Articles

  def create(conn, %{"micropost" => micropost_params}) do
    case Articles.create_micropost(micropost_params, current_user(conn)) do
      {:ok, %Micropost{}} ->
        conn
        |> put_flash(:info, "Micropost created successfully.")
        |> redirect(to: root_path(conn, :home))
      {:error, %Ecto.Changeset{} = changeset} ->
        feed_items = Articles.list_microposts_paginated(current_user(conn))
        conn
        |> render(SampleAppWeb.StaticPageView, "home.html", changeset: changeset, feed_items: feed_items)
    end
  end

  def delete(conn, _) do
    micropost = conn.assigns[:micropost]
    {:ok, _micropost} = Articles.delete_micropost(micropost)

    conn
    |> put_flash(:info, "Micropost deleted successfully.")
    |> redirect(external: (referer_url(conn) || root_url(conn, :home)))
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  defp referer_url(conn) do
    [referer_url] = get_req_header(conn, "referer")
    referer_url
  end
end

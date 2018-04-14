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
        IO.inspect SampleAppWeb.ErrorHelpers.error_tag(changeset, :content)
        conn
        |> render(SampleAppWeb.StaticPageView, "home.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    micropost = Articles.get_micropost!(id)
    {:ok, _micropost} = Articles.delete_micropost(micropost)

    conn
    |> put_flash(:info, "Micropost deleted successfully.")
    |> redirect(to: micropost_path(conn, :index))
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end
end

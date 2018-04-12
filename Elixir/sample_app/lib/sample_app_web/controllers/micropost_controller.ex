defmodule SampleAppWeb.MicropostController do
  use SampleAppWeb, :controller

  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost

  def create(conn, %{"micropost" => micropost_params}) do
    case Articles.create_micropost(micropost_params) do
      {:ok, micropost} ->
        conn
        |> put_flash(:info, "Micropost created successfully.")
        |> redirect(to: micropost_path(conn, :show, micropost))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    micropost = Articles.get_micropost!(id)
    {:ok, _micropost} = Articles.delete_micropost(micropost)

    conn
    |> put_flash(:info, "Micropost deleted successfully.")
    |> redirect(to: micropost_path(conn, :index))
  end
end

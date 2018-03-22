defmodule ToyAppWeb.MicropostController do
  use ToyAppWeb, :controller

  alias ToyApp.Articles
  alias ToyApp.Articles.Micropost

  def index(conn, _params) do
    microposts = Articles.list_microposts()
    render(conn, "index.html", microposts: microposts)
  end

  def new(conn, _params) do
    changeset = Articles.change_micropost(%Micropost{})
    render(conn, "new.html", changeset: changeset)
  end

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

  def show(conn, %{"id" => id}) do
    micropost = Articles.get_micropost!(id)
    render(conn, "show.html", micropost: micropost)
  end

  def edit(conn, %{"id" => id}) do
    micropost = Articles.get_micropost!(id)
    changeset = Articles.change_micropost(micropost)
    render(conn, "edit.html", micropost: micropost, changeset: changeset)
  end

  def update(conn, %{"id" => id, "micropost" => micropost_params}) do
    micropost = Articles.get_micropost!(id)

    case Articles.update_micropost(micropost, micropost_params) do
      {:ok, micropost} ->
        conn
        |> put_flash(:info, "Micropost updated successfully.")
        |> redirect(to: micropost_path(conn, :show, micropost))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", micropost: micropost, changeset: changeset)
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

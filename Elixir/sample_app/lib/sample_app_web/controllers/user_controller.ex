defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias SampleApp.Articles
  alias SampleAppWeb.Auth

  def new(conn, _) do
    changeset = User.changeset(%User{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def show(conn, %{"id" => id} = params) do
    user = Accounts.get_user!(id)
    microposts = Articles.list_microposts_paginated(params, user)
    conn
    |> render(:show, user: user, microposts: microposts)
  end

  def index(conn, params) do
    page = Accounts.list_users_paginated(params)
    conn
    |> render(:index, page: page)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:success, "Welcome to the Sample App")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, error_message(changeset))
        |> render(:new, changeset: changeset)
    end
  end

  def edit(conn, _) do
    user = conn.assigns[:current_user]
    changeset = User.changeset(user, %{})
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns[:current_user]

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, error_message(changeset))
        |> render(:edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    Accounts.delete_user(user)

    conn
    |> put_flash(:success, "User deleted")
    |> redirect(to: user_path(conn, :index))
  end

  defp error_message(%{errors: errors}) do
    case Enum.count(errors) do
      0 -> ""
      1 -> "The form contains an error."
      count -> "The form contains #{count} errors."
    end
  end
end

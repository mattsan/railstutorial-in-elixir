defmodule SampleAppWeb.SessionController do
  use SampleAppWeb, :controller

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User

  def new(conn, _) do
    changeset = User.changeset(%User{}, %{})
    conn
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user =
      with %User{} = user <- Accounts.get_user_by(email: String.downcase(email)),
           true <- Bcrypt.verify_pass(password, user.password_digest),
           do: user

    case user do
      %User{} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: user_path(conn, :show, user))
      _ ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: session_path(conn, :new))
  end
end

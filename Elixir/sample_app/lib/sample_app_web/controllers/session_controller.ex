defmodule SampleAppWeb.SessionController do
  use SampleAppWeb, :controller

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias SampleAppWeb.Auth

  def new(conn, _) do
    conn
    |> render(:new)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password, "remember_me" => remember_me}}) do
    user =
      with %User{} = user <- Accounts.get_user_by(email: String.downcase(email)),
           true <- Bcrypt.verify_pass(password, user.password_digest),
           do: user

    case user do
      %User{} ->
        conn
        |> Auth.login(user)
        |> Auth.remember_if(user, String.to_atom(remember_me))
        |> Auth.redirect_back_or(user_path(conn, :show, user))
      _ ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn =
      case conn.assigns[:current_user] do
        nil ->
          conn

        user ->
          conn
          |> Auth.forget(user)
      end

    conn
    |> Auth.logout()
    |> redirect(to: session_path(conn, :new))
  end
end

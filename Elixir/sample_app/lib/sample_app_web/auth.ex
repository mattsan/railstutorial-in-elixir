defmodule SampleAppWeb.Auth do
  import Plug.Conn

  alias SampleApp.Accounts

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
  end

  def logout(conn) do
    conn
    |> delete_session(:user_id)
  end

  def remember(conn, user) do
    remember_token = Accounts.remember_user(user)

    conn
    |> put_resp_cookie("user_id", Integer.to_string(user.id), max_age: 631_152_000)
    |> put_resp_cookie("remember_token", remember_token, max_age: 631_152_000)
  end

  def forget(conn, user) do
    Accounts.forget_user(user)

    conn
    |> delete_resp_cookie("user_id")
    |> delete_resp_cookie("remember_token")
  end

  def remember_if(conn, user, remember_me) do
    if remember_me do
      remember(conn, user)
    else
      forget(conn, user)
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def logged_in?(conn) do
    current_user(conn) |> is_nil() |> Kernel.not()
  end
end

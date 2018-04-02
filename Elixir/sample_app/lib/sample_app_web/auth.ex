defmodule SampleAppWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

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

  def current_user?(conn) do
    user = conn.assigns[:current_user]
    id = conn.path_params["id"] |> String.to_integer
    user.id == id
  end

  def redirect_back_or(conn, default_url) do
    forwarding_url = get_session(conn, :forwarding_url) || default_url

    conn
    |> delete_session(:forwarding_url)
    |> redirect(to: forwarding_url)
  end

  def store_location(conn) do
    case conn.method do
      "GET" ->
        conn
        |> put_session(:forwarding_url, conn.request_path)
      _ ->
        conn
    end
  end

  # plug

  def assign_current_user(conn, _) do
    cond do
      (user_id = get_session(conn, :user_id)) != nil ->
        case SampleApp.Accounts.get_user_by(id: user_id) do
          nil ->
            conn
          user ->
            conn
            |> assign(:current_user, user)
        end
      (user_id = conn.cookies["user_id"]) != nil ->
        user = SampleApp.Accounts.get_user_by(id: user_id)
        if user && SampleApp.Accounts.authenticated?(user, conn.cookies["remember_token"]) do
          conn
          |> put_session(:user_id, user.id)
          |> assign(:current_user, user)
        else
          conn
        end
      true ->
        conn
    end
  end

  def permit_logged_in_user(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> store_location()
        |> put_flash(:error, "Please log in")
        |> redirect(to: SampleAppWeb.Router.Helpers.session_path(conn, :new))
        |> halt()
      _ ->
        conn
    end
  end

  def correct_user(conn, _) do
    if current_user?(conn) do
      conn
    else
      conn
      |> redirect(to: SampleAppWeb.Router.Helpers.root_path(conn, :home))
      |> halt()
    end
  end

  def admin_user(conn, _) do
    if current_user(conn).admin do
      conn
    else
      conn
      |> redirect(to: SampleAppWeb.Router.Helpers.root_path(conn, :home))
      |> halt()
    end
  end
end

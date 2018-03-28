defmodule SampleAppWeb.UserLoginTest do
  use SampleAppWeb.IntegrationCase, async: true

  alias SampleApp.Accounts

  @valid_user_params  %{
    name: "foo",
    email: "foo@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  }

  setup do
    Accounts.create_user(@valid_user_params)
    :ok
  end

  test "login with invalid informatin", %{conn: conn} do
    conn
    |> get(session_path(conn, :new))
    |> assert_response(
        status: 200
      )
    |> submit_form(%{user: %{email: "", password: ""}})
    |> assert_response(
        redirect: session_path(conn, :new)
      )
  end

  test "login with valid information followed by logout", %{conn: conn} do
    user = Accounts.get_user_by(email: @valid_user_params.email)

    conn
    |> get(session_path(conn, :new))
    |> submit_form(%{user: %{email: @valid_user_params.email, password: @valid_user_params.password}})
    |> assert_response(
        redirect: user_path(conn, :show, user)
      )
    |> get(user_path(conn, :show, user))
    |> assert_response(
        status: 200,
        html: ~s[>Users</a>],
        html: ~s[Account <b class="caret"></b>],
        html: ~s[>Profile</a>],
        html: ~s[>Settings</a>],
        html: ~s[>Log out</a>]
      )
    |> refute_response(
        html: ~s[>Log in</a>]
      )
    |> delete(session_path(conn, :delete))
    |> assert_response(
        redirect: session_path(conn, :new)
      )
    |> get(session_path(conn, :new))
    |> assert_response(
        status: 200,
        html: ~s[>Log in</a>]
      )
    |> refute_response(
        html: ~s[>Users</a>],
        html: ~s[Account <b class="caret"></b>],
        html: ~s[>Profile</a>],
        html: ~s[>Settings</a>],
        html: ~s[>Log out</a>]
      )
  end
end

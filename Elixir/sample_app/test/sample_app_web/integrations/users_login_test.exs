defmodule SampleAppWeb.UserLoginTest do
  use SampleAppWeb.IntegrationCase, async: true

  alias SampleApp.Accounts
  alias SampleAppWeb.Auth

  @valid_user_params  %{
    name: "foo",
    email: "foo@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  }

  def tap(conn, fun) do
    fun.(conn)
    conn
  end

  setup do
    Accounts.create_user(@valid_user_params)
    :ok
  end

  test "login with invalid informatin", %{conn: conn} do
    refute Auth.logged_in?(conn)

    conn
    |> get(session_path(conn, :new))
    |> assert_response(
        status: 200
      )
    |> submit_form(%{session: %{email: "", password: ""}})
    |> assert_response(
        redirect: session_path(conn, :new)
      )

    refute Auth.logged_in?(conn)
  end

  test "login with valid information followed by logout", %{conn: conn} do
    user = Accounts.get_user_by(email: @valid_user_params.email)

    refute Auth.logged_in?(conn)

    conn
    |> get(session_path(conn, :new))
    |> submit_form(%{session: %{email: @valid_user_params.email, password: @valid_user_params.password}})
    |> assert_response(
        redirect: user_path(conn, :show, user)
      )
    |> get(user_path(conn, :show, user))
    |> tap(
        &(assert Auth.logged_in?(&1))
      )
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
    |> tap(
        &(refute Auth.logged_in?(&1))
      )
    |> assert_response(
        status: 200,
        html: ~s[>Log in</a>]
      )
    |> delete(session_path(conn, :delete))
    |> get(session_path(conn, :new))
    |> refute_response(
        html: ~s[>Users</a>],
        html: ~s[Account <b class="caret"></b>],
        html: ~s[>Profile</a>],
        html: ~s[>Settings</a>],
        html: ~s[>Log out</a>]
      )
  end

  describe "remembering" do
    setup %{conn: conn, remember_me: remember_me} do
      user = Accounts.get_user_by(email: @valid_user_params.email)
      [
        conn:
        conn
        |> get(session_path(conn, :new))
        |> submit_form(%{session: %{email: @valid_user_params.email, password: @valid_user_params.password, remember_me: remember_me}})
        |> get(user_path(conn, :show, user))
      ]
    end

    @tag remember_me: "false"
    test "login with remembering", %{conn: conn} do
      refute conn.cookies["remember_token"]
    end

    @tag remember_me: "true"
    test "login without remembering", %{conn: conn} do
      assert conn.cookies["remember_token"]
    end
  end
end

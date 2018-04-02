defmodule SampleAppWeb.UseControllerTest do
  use SampleAppWeb.ConnCase

  alias SampleApp.Accounts

  def user_params(user_name) do
    %{
      name: user_name,
      email: "#{user_name}@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  def log_in_as(conn, user) do
    user_params = %{
      "session" => %{
        "email" => user.email,
        "password" => "password",
        "remember_me" => "false"
      }
    }

    post(conn, session_path(conn, :create), user_params)
  end

  setup do
    {:ok, user} = Accounts.create_user(user_params("foo"))
    {:ok, other_user} = Accounts.create_user(user_params("bar"))
    [user: user, other_user: other_user]
  end

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(user_path(conn, :new))
      |> html_response(200)
    assert response =~ "Hello SampleApp!"
  end

  describe "when not logged in" do
    test "should redirect edit when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> get(user_path(conn, :edit, user))
        |> redirected_to()

      assert path == session_path(conn, :new)
    end

    test "should redirect update when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> patch(user_path(conn, :update, user))
        |> redirected_to()

      assert path == session_path(conn, :new)
    end

    test "should redirect index when not logged in", %{conn: conn} do
      path =
        conn
        |> get(user_path(conn, :index))
        |> redirected_to()

      assert path == session_path(conn, :new)
    end

    test "should redirect destroy when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> delete(user_path(conn, :delete, user))
        |> redirected_to()

      assert path == session_path(conn, :new)
    end
  end

  describe "when logged in as wrong user" do
    setup %{conn: conn, other_user: other_user} do
      [conn: log_in_as(conn, other_user)]
    end

    test "should redirect edit when logged in as wrong user", %{conn: conn, user: user} do
      path =
        conn
        |> get(user_path(conn, :edit, user))
        |> redirected_to()

      assert path == root_path(conn, :home)
    end

    test "should redirect update when logged in as wrong user", %{conn: conn, user: user} do
      path =
        conn
        |> patch(user_path(conn, :update, user))
        |> redirected_to()

      assert path == root_path(conn, :home)
    end

    test "should redirect destroy when logged in as a non-admin", %{conn: conn, user: user} do
      before_count = Accounts.count_users()

      path =
        conn
        |> delete(user_path(conn, :delete, user))
        |> redirected_to()

      after_count = Accounts.count_users()

      assert path == root_path(conn, :home)
      assert before_count == after_count
    end
  end

  describe "a non-admin" do
  end
end

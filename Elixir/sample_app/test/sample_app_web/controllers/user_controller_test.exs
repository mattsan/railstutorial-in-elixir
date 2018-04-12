defmodule SampleAppWeb.UseControllerTest do
  use SampleAppWeb.ConnCase

  alias SampleApp.Accounts

  import SampleAppWeb.TestHelper

  setup do
    user = create_user("foo")
    other_user = create_user("bar")

    [user: user, other_user: other_user]
  end

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(signup_path(@endpoint, :new))
      |> html_response(200)

    assert response =~ "Ruby on Rails Tutorial Sample App"
  end

  describe "when not logged in" do
    test "should redirect edit when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> get(user_path(@endpoint, :edit, user))
        |> redirected_to()

      assert path == session_path(@endpoint, :new)
    end

    test "should redirect update when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> patch(user_path(@endpoint, :update, user))
        |> redirected_to()

      assert path == session_path(@endpoint, :new)
    end

    test "should redirect index when not logged in", %{conn: conn} do
      path =
        conn
        |> get(user_path(@endpoint, :index))
        |> redirected_to()

      assert path == session_path(@endpoint, :new)
    end

    test "should not allow the admin attribute to be edited via the web",  %{conn: conn, other_user: other_user} do
      refute other_user.admin

      conn
      |> log_in_as(other_user)
      |> patch(user_path(@endpoint, :update, other_user), %{
          user: %{
            name: other_user.name,
            email: other_user.email,
            password: "password",
            password_confirmation: "password",
            admin: true
          }
        })

      refute Accounts.get_user!(other_user.id).admin
    end

    test "should redirect destroy when not logged in", %{conn: conn, user: user} do
      path =
        conn
        |> delete(user_path(@endpoint, :delete, user))
        |> redirected_to()

      assert path == session_path(@endpoint, :new)
    end
  end

  describe "when logged in as wrong user" do
    setup %{conn: conn, other_user: other_user} do
      [conn: log_in_as(conn, other_user)]
    end

    test "should redirect edit when logged in as wrong user", %{conn: conn, user: user} do
      path =
        conn
        |> get(user_path(@endpoint, :edit, user))
        |> redirected_to()

      assert path == root_path(@endpoint, :home)
    end

    test "should redirect update when logged in as wrong user", %{conn: conn, user: user} do
      path =
        conn
        |> patch(user_path(@endpoint, :update, user))
        |> redirected_to()

      assert path == root_path(@endpoint, :home)
    end

    test "should redirect destroy when logged in as a non-admin", %{conn: conn, user: user} do
      before_count = Accounts.count_users()

      path =
        conn
        |> delete(user_path(@endpoint, :delete, user))
        |> redirected_to()

      after_count = Accounts.count_users()

      assert path == root_path(@endpoint, :home)
      assert before_count == after_count
    end
  end
end

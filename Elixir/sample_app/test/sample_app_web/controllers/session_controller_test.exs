defmodule SampleAppWeb.SessionControllerTest do
  use SampleAppWeb.ConnCase

  import SampleAppWeb.TestHelper

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(session_path(@endpoint, :new))
      |> html_response(200)

    assert response =~ tag_string(:input, class: "form-control", id: "session_email", name: "session[email]", type: "text")
    assert response =~ tag_string(:input, class: "form-control", id: "session_password", name: "session[password]", type: "password")
  end

  test "log in", %{conn: conn} do
    user = create_user("foo")

    conn = get(conn, session_path(@endpoint, :new))

    refute is_logged_in?(conn)

    conn = log_in_as(conn, user)

    assert is_logged_in?(conn)
    assert redirected_to(conn) == user_path(@endpoint, :show, user)

    conn = delete(conn, session_path(@endpoint, :delete))

    refute is_logged_in?(conn)
    assert redirected_to(conn) == session_path(@endpoint, :new)

    conn = delete(conn, session_path(@endpoint, :delete))

    refute is_logged_in?(conn)
    assert redirected_to(conn) == session_path(@endpoint, :new)
  end
end

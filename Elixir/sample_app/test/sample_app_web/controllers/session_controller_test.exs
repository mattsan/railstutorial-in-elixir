defmodule SampleAppWeb.SessionControllerTest do
  use SampleAppWeb.ConnCase

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(session_path(conn, :new))
      |> html_response(200)
    assert response =~ ~s{<input class="form-control" id="user_email" name="user[email]" type="text">}
    assert response =~ ~s{<input class="form-control" id="user_password" name="user[password]" type="password">}
  end
end

defmodule SampleAppWeb.SessionControllerTest do
  use SampleAppWeb.ConnCase

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(session_path(conn, :new))
      |> html_response(200)
    assert response =~ ~s{<input class="form-control" id="session_email" name="session[email]" type="text">}
    assert response =~ ~s{<input class="form-control" id="session_password" name="session[password]" type="password">}
  end
end

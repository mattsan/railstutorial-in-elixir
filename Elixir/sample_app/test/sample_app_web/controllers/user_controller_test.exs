defmodule SampleAppWeb.UseControllerTest do
  use SampleAppWeb.ConnCase

  test "should get new", %{conn: conn} do
    response =
      conn
      |> get(user_path(conn, :new))
      |> html_response(200)
    assert response =~ "Hello SampleApp!"
  end
end

defmodule SampleAppWeb.StaticPageControllerTest do
  use SampleAppWeb.ConnCase

  test "should get root", %{conn: conn} do
    response =
      conn
      |> get(root_path(conn, :home))
      |> html_response(200)
    assert response =~ "Sample App"
    assert response =~ "<title>Hello SampleApp!</title>"
  end

  test "should get home", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(conn, :home))
      |> html_response(200)
    assert response =~ "Sample App"
    assert response =~ "<title>Hello SampleApp!</title>"
  end

  test "should get help", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(conn, :help))
      |> html_response(200)
    assert response =~ "Help"
    assert response =~ "<title>Hello SampleApp! | Help</title>"
  end

  test "should get about", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(conn, :about))
      |> html_response(200)
    assert response =~ "About"
    assert response =~ "<title>Hello SampleApp! | About</title>"
  end
end

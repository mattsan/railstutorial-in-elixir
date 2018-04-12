defmodule SampleAppWeb.StaticPageControllerTest do
  use SampleAppWeb.ConnCase

  import SampleAppWeb.TestHelper

  test "should get home", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(@endpoint, :home))
      |> html_response(200)
    assert response =~ content_tag_string(:title, "Ruby on Rails Tutorial Sample App")
  end

  test "should get help", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(@endpoint, :help))
      |> html_response(200)
    assert response =~ content_tag_string(:title, "Help | Ruby on Rails Tutorial Sample App")
  end

  test "should get about", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(@endpoint, :about))
      |> html_response(200)
    assert response =~ content_tag_string(:title, "About | Ruby on Rails Tutorial Sample App")
  end

  test "should get contact", %{conn: conn} do
    response =
      conn
      |> get(static_page_path(@endpoint, :contact))
      |> html_response(200)
    assert response =~ content_tag_string(:title, "Contact | Ruby on Rails Tutorial Sample App")
  end
end

defmodule SampleAppWeb.SiteLayoutTest do
  use SampleAppWeb.IntegrationCase, async: true

  test "layout links", %{conn: conn} do
    conn
    |> get(root_path(conn, :home))
    |> assert_response(
        status: 200,
        html: ~s[<a href="#{root_path(conn, :home)}" id="logo">sample app</a>],
        html: ~s[<a href="#{root_path(conn, :home)}">Home</a>],
        html: ~s[<a href="#{static_page_path(conn, :help)}">Help</a>],
        html: ~s[<a href="#{static_page_path(conn, :about)}">About</a>],
        html: ~s[<a href="#{static_page_path(conn, :contact)}">Contact</a>]
      )
    |> follow_link("Contact")
    |> assert_response(
        status: 200,
        html: ~s[<title>Hello SampleApp! | Contact</title>]
      )
  end
end

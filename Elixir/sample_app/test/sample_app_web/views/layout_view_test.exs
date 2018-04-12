defmodule SampleAppWeb.LayoutViewTest do
  use SampleAppWeb.ConnCase, async: true

  import SampleAppWeb.LayoutView, only: [page_title: 1]
  import Plug.Conn, only: [put_private: 3]

  describe "page_title" do
    setup %{conn: conn} = context do
      view = Map.get(context, :view)
      action = Map.get(context, :action)
      [conn: conn |> put_private(:phoenix_view, view) |> put_private(:phoenix_action, action)]
    end

    @tag view: SampleAppWeb.StaticPageView, action: :home
    test "home page", %{conn: conn} do
      assert page_title(conn) == "Ruby on Rails Tutorial Sample App"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :about
    test "about page", %{conn: conn} do
      assert page_title(conn) == "About | Ruby on Rails Tutorial Sample App"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :help
    test "help page", %{conn: conn} do
      assert page_title(conn) == "Help | Ruby on Rails Tutorial Sample App"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :contact
    test "contact page", %{conn: conn} do
      assert page_title(conn) == "Contact | Ruby on Rails Tutorial Sample App"
    end

    @tag view: SampleAppWeb.UserView, action: :new
    test "sign up page", %{conn: conn} do
      assert page_title(conn) == "Sign up | Ruby on Rails Tutorial Sample App"
    end
  end
end

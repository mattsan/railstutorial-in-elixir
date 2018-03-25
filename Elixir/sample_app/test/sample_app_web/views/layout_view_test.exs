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
      assert page_title(conn) == "Hello SampleApp!"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :about
    test "about page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp! | About"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :help
    test "help page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp! | Help"
    end

    @tag view: SampleAppWeb.StaticPageView, action: :contact
    test "contact page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp! | Contact"
    end

    @tag view: SampleAppWeb.UserView, action: :new
    test "sign up page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp! | Sign up"
    end
  end
end

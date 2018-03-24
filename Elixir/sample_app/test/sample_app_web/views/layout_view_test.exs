defmodule SampleAppWeb.LayoutViewTest do
  use SampleAppWeb.ConnCase, async: true

  import SampleAppWeb.LayoutView, only: [page_title: 1]

  describe "page_title" do
    setup %{conn: conn} = context do
      case Map.get(context, :title) do
        nil ->
          :ok
        title ->
          [conn: Plug.Conn.assign(conn, :title, title)]
      end
    end

    test "home page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp!"
    end

    @tag title: "About"
    test "about page", %{conn: conn} do
      assert page_title(conn) == "Hello SampleApp! | About"
    end
  end
end

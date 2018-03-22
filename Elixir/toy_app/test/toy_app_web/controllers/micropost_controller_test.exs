defmodule ToyAppWeb.MicropostControllerTest do
  use ToyAppWeb.ConnCase

  alias ToyApp.Articles

  @create_attrs %{content: "some content", user_id: 42}
  @update_attrs %{content: "some updated content", user_id: 43}
  @invalid_attrs %{content: nil, user_id: nil}

  def fixture(:micropost) do
    {:ok, micropost} = Articles.create_micropost(@create_attrs)
    micropost
  end

  describe "index" do
    test "lists all microposts", %{conn: conn} do
      conn = get conn, micropost_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Microposts"
    end
  end

  describe "new micropost" do
    test "renders form", %{conn: conn} do
      conn = get conn, micropost_path(conn, :new)
      assert html_response(conn, 200) =~ "New Micropost"
    end
  end

  describe "create micropost" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, micropost_path(conn, :create), micropost: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == micropost_path(conn, :show, id)

      conn = get conn, micropost_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Micropost"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, micropost_path(conn, :create), micropost: @invalid_attrs
      assert html_response(conn, 200) =~ "New Micropost"
    end
  end

  describe "edit micropost" do
    setup [:create_micropost]

    test "renders form for editing chosen micropost", %{conn: conn, micropost: micropost} do
      conn = get conn, micropost_path(conn, :edit, micropost)
      assert html_response(conn, 200) =~ "Edit Micropost"
    end
  end

  describe "update micropost" do
    setup [:create_micropost]

    test "redirects when data is valid", %{conn: conn, micropost: micropost} do
      conn = put conn, micropost_path(conn, :update, micropost), micropost: @update_attrs
      assert redirected_to(conn) == micropost_path(conn, :show, micropost)

      conn = get conn, micropost_path(conn, :show, micropost)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, micropost: micropost} do
      conn = put conn, micropost_path(conn, :update, micropost), micropost: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Micropost"
    end
  end

  describe "delete micropost" do
    setup [:create_micropost]

    test "deletes chosen micropost", %{conn: conn, micropost: micropost} do
      conn = delete conn, micropost_path(conn, :delete, micropost)
      assert redirected_to(conn) == micropost_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, micropost_path(conn, :show, micropost)
      end
    end
  end

  defp create_micropost(_) do
    micropost = fixture(:micropost)
    {:ok, micropost: micropost}
  end
end

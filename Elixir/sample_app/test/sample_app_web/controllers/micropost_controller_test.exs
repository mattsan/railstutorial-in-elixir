defmodule SampleAppWeb.MicropostControllerTest do
  use SampleAppWeb.ConnCase

  alias SampleApp.Repo

  import SampleAppWeb.TestHelper

  setup do
    {:ok, micropost} =
      create_user("foo")
      |> Ecto.build_assoc(:microposts, %{content: "I just ate an orange!"})
      |> Repo.insert()

    [micropost: micropost]
  end

  test "should redirect create when not logged in", %{conn: conn} do
    conn = post(conn, micropost_path(@endpoint, :create), %{micropost: %{content: "Lorem ipsum"}})
    assert redirected_to(conn) == session_path(@endpoint, :new)
  end

  test "should redirect delete when not logged in", %{conn: conn, micropost: micropost} do
    conn = delete(conn, micropost_path(@endpoint, :delete, micropost), %{micropost: %{content: "Lorem ipsum"}})
    assert redirected_to(conn) == session_path(@endpoint, :new)
  end
end

defmodule SampleAppWeb.MicropostControllerTest do
  use SampleAppWeb.ConnCase

  alias SampleApp.Repo
  alias SampleApp.Articles.Micropost

  import SampleAppWeb.TestHelper

  setup do
    user = create_user("foo")

    {:ok, micropost} =
      user
      |> Ecto.build_assoc(:microposts, %{content: Faker.Lorem.sentence()})
      |> Repo.insert()

    {:ok, other_micropost} =
      create_user("bar")
      |> Ecto.build_assoc(:microposts, %{content: Faker.Lorem.sentence()})
      |> Repo.insert()

    [usr: user, micropost: micropost, other_micropost: other_micropost]
  end

  test "should redirect create when not logged in", %{conn: conn} do
    conn = post(conn, micropost_path(@endpoint, :create), %{micropost: %{content: "Lorem ipsum"}})
    assert redirected_to(conn) == session_path(@endpoint, :new)
  end

  test "should redirect delete when not logged in", %{conn: conn, micropost: micropost} do
    conn = delete(conn, micropost_path(@endpoint, :delete, micropost))
    assert redirected_to(conn) == session_path(@endpoint, :new)
  end

  test "should redirect delete for wrong micropost", %{conn: conn, usr: user, other_micropost: other_micropost} do
    conn = log_in_as(conn, user)

    assert redirected_to(conn) == user_path(@endpoint, :show, user)

    before_count = Micropost |> Repo.aggregate(:count, :id)

    conn = delete(conn, micropost_path(@endpoint, :delete, other_micropost))

    after_count = Micropost |> Repo.aggregate(:count, :id)

    assert before_count == after_count

    assert redirected_to(conn) == root_path(@endpoint, :home)
  end
end

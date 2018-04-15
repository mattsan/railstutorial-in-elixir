defmodule SampleAppWeb.MicropostsInterfaceTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  alias SampleApp.Repo
  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost

  import SampleAppWeb.TestHelper

  hound_session()

  def log_in(user) do
    navigate_to(session_path(@endpoint, :new))
    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()
    user
  end

  setup do
    user =
      create_user("foo")
      |> log_in()

    other_user = create_user("bar")
    Articles.create_micropost(%{content: Faker.Lorem.sentence()}, other_user)

    [user: user, other_user: other_user]
  end

  test "micropost interface", %{other_user: other_user} do
    navigate_to(root_path(@endpoint, :home))

    assert find_element(:class, "pagination") |> element_displayed?()

    assert_diff Repo.aggregate(Micropost, :count, :id), 0 do
      fill_field({:tag, "textarea"}, "")
      submit_element({:tag, "button"})
    end

    assert_diff Repo.aggregate(Micropost, :count, :id), 1 do
      content = "This micropost really ties the room together"
      fill_field({:tag, "textarea"}, content)
      submit_element({:tag, "button"})
      assert visible_page_text() =~ content
    end

    assert_diff Repo.aggregate(Micropost, :count, :id), -1 do
      click({:link_text, "delete"})
    end

    navigate_to(user_path(@endpoint, :show, other_user))
    refute visible_in_page?(~r/delete/)
  end
end

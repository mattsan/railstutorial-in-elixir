defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  import SampleAppWeb.TestHelper, except: [log_in_as: 2]

  hound_session()

  def log_in_as(email, password) do
    navigate_to(session_path(@endpoint, :new))
    fill_field({:id, "session_email"}, email)
    fill_field({:id, "session_password"}, password)
    find_element(:tag, "button") |> submit_element()
  end

  setup do
    user = create_user("foo")
    [user: user]
  end

  describe "user logged in" do
    setup %{user: user} do
      log_in_as(user.email, "password")
      :ok
    end

    test "unsuccessful edit", %{user: user} do
      navigate_to(user_path(@endpoint, :edit, user))

      assert current_path() == user_path(@endpoint, :edit, user)

      fill_field({:id, "user_name"}, "")
      fill_field({:id, "user_email"}, "foo@envalid")
      fill_field({:id, "user_password"}, "foo")
      fill_field({:id, "user_password_confirmation"}, "bar")
      find_element(:tag, "button") |> submit_element()

      assert page_title() == "Ruby on Rails Tutorial Sample App"
      assert find_element(:class, "alert-danger") |> inner_text == "The form contains 4 errors."
    end

    test "successful edit", %{user: user} do
      navigate_to(user_path(@endpoint, :edit, user))

      assert current_path() == user_path(@endpoint, :edit, user)

      name = "Foo Bar"
      email = "foo@bar.com"

      fill_field({:id, "user_name"}, name)
      fill_field({:id, "user_email"}, email)
      fill_field({:id, "user_password"}, "")
      fill_field({:id, "user_password_confirmation"}, "")
      find_element(:tag, "button") |> submit_element()

      assert page_title() == "Foo Bar | Ruby on Rails Tutorial Sample App"
      assert find_element(:class, "alert-danger") |> inner_text == ""
    end
  end

  test "successful edit with friendly forwarding", %{user: user} do
    navigate_to(user_path(@endpoint, :edit, user))

    assert current_path() == session_path(@endpoint, :new)

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(@endpoint, :edit, user)
  end
end

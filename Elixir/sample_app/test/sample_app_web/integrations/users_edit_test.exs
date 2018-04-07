defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  import SampleAppWeb.TestHelper

  hound_session()

  setup do
    [user: create_user("foo")]
  end

  test "successful edit with frendly forwarding", %{user: user} do
    navigate_to(user_path(@endpoint, :edit, user))

    assert current_path() == session_path(@endpoint, :new)

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(@endpoint, :edit, user)
  end
end

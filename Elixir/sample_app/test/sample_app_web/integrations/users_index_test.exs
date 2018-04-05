defmodule SampleWebApp.UserIndexTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  import SampleAppWeb.TestHelper

  hound_session()

  setup do
    user = create_user("foo")

    1..35
    |> Enum.map(&"user-#{&1}")
    |> create_users()

    [user: user]
  end

  test "index including pagination", %{user: user} do
    navigate_to(session_path(@endpoint, :new))

    assert current_path() == session_path(@endpoint, :new)

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(@endpoint, :show, user)

    navigate_to(user_path(@endpoint, :index))

    assert element?(:class, "pagination")
  end
end

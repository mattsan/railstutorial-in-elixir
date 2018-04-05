defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  import SampleAppWeb.TestHelper

  hound_session()

  setup do
    [user: create_user("foo")]
  end

  test "successful edit with frendly forwarding", %{conn: conn, user: user} do
    navigate_to(user_path(conn, :edit, user))

    assert current_path() == session_path(conn, :new)

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(conn, :edit, user)
  end
end

defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  hound_session()

  def user_params(user_name) do
    %{
      name: "#{user_name}",
      email: "#{user_name}@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  setup do
    {:ok, user} = SampleApp.Accounts.create_user(user_params("foo"))
    [user: user]
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

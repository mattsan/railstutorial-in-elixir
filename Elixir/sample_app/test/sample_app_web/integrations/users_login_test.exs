defmodule SampleAppWeb.UserLoginTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  import SampleAppWeb.TestHelper, only: [create_user: 1]

  hound_session()

  setup do
    [user: create_user("foo")]
  end

  test "login with invalid informatin" do
    navigate_to(session_path(@endpoint, :new))

    assert current_path() == session_path(@endpoint, :new)

    fill_field({:id, "session_email"}, "")
    fill_field({:id, "session_password"}, "")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == session_path(@endpoint, :new)

    refute find_element(:class, "alert-danger") |> inner_text() == ""

    navigate_to(root_path(@endpoint, :home))

    assert find_element(:class, "alert-danger") |> inner_text() == ""
  end

  test "login with valid information followed by logout", %{user: user} do
    navigate_to(session_path(@endpoint, :new))

    assert current_path() == session_path(@endpoint, :new)

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(@endpoint, :show, user)

    assert find_element(:link_text, "Users") |> attribute_value("href") == user_url(@endpoint, :index)
    assert find_element(:partial_link_text, "Account") |> click()
    assert find_element(:link_text, "Profile") |> attribute_value("href") == user_url(@endpoint, :show, user)
    assert find_element(:link_text, "Settings") |> attribute_value("href") == user_url(@endpoint, :edit, user)
    assert find_element(:link_text, "Log out") |> attribute_value("data-to") == session_path(@endpoint, :delete)
    refute visible_in_page?(~r/Log in/)

    find_element(:link_text, "Log out") |> click()

    assert current_path() == session_path(@endpoint, :new)

    assert find_element(:link_text, "Log in") |> attribute_value("href") == session_url(@endpoint, :new)
    refute visible_in_page?(~r/Users/)
    refute visible_in_page?(~r/Account/)
    refute visible_in_page?(~r/Profile/)
    refute visible_in_page?(~r/Setting/)
    refute visible_in_page?(~r/Log out/)
  end

  def log_in_as(user, remember_me: remember_me) do
    navigate_to(session_path(@endpoint, :new))
    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    if remember_me do
      find_element(:id, "session_remember_me") |> click()
    end

    find_element(:tag, "button") |> submit_element()
  end

  describe "remembering" do
    test "login with remembering", %{user: user} do
      log_in_as(user, remember_me: true)
      assert cookies() |> Enum.find(&(&1["name"] == "remember_token")) |> Map.get("value")
    end

    test "login without remembering", %{conn: conn, user: user} do
      log_in_as(user, remember_me: true)
      delete(conn, session_path(@endpoint, :delete))
      log_in_as(user, remember_me: false)
      refute cookies() |> Enum.find(&(&1["name"] == "remember_token"))
    end

  end
end

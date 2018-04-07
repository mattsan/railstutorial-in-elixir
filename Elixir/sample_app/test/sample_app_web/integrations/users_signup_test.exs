defmodule SampleAppWeb.UserSignupTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  alias SampleApp.Accounts

  hound_session()

  test "invalid signup information" do
    user_params = %{
      name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar"
    }

    navigate_to(signup_path(@endpoint, :new))

    fill_field({:id, "user_name"}, user_params.name)
    fill_field({:id, "user_email"}, user_params.email)
    fill_field({:id, "user_password"}, user_params.password)
    fill_field({:id, "user_password_confirmation"}, user_params.password_confirmation)
    find_element(:tag, "button") |> submit_element()

    assert current_path() == user_path(@endpoint, :create)
    refute find_element(:class, "alert-danger") |> inner_text() == ""
  end

  test "valid signup information" do
    user_params = %{
      name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }

    navigate_to(signup_path(@endpoint, :new))

    fill_field({:id, "user_name"}, user_params.name)
    fill_field({:id, "user_email"}, user_params.email)
    fill_field({:id, "user_password"}, user_params.password)
    fill_field({:id, "user_password_confirmation"}, user_params.password_confirmation)
    find_element(:tag, "button") |> submit_element()

    user = Accounts.get_user_by(email: user_params.email)

    assert current_path() == user_path(@endpoint, :show, user)
    assert find_element(:class, "alert-danger") |> inner_text() == ""
  end
end

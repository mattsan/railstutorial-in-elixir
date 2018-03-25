defmodule SampleAppWeb.UserSignupTest do
  use SampleAppWeb.IntegrationCase, async: true

  test "invalid signup information", %{conn: conn} do
    user_params = %{
      name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar"
    }

    conn
    |> get(user_path(conn, :new))
    |> submit_form(%{user: user_params})
    |> assert_response(
        status: 200,
        path: user_path(conn, :create)
      )
  end

  test "valid signup information", %{conn: conn} do
    user_params = %{
      name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }

    conn
    |> get(user_path(conn, :new))
    |> submit_form(%{user: user_params})
    |> assert_response(
        redirect: user_path(conn, :show, SampleApp.Accounts.get_user_by(email: "user@example.com"))
      )
  end
end

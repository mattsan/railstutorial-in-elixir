defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.IntegrationCase, async: true

  def create_user(user_name) do
    {:ok, user} = SampleApp.Accounts.create_user(user_params(user_name))
    [{user_name, user}]
  end

  setup do
    create_user(:user)
  end

  test "successful edit with frendly forwarding", %{conn: conn, user: user} do
    conn
    |> get(user_path(conn, :edit, user))
    |> assert_response(
        redirect: session_path(conn, :new)
      )
    |> get(session_path(conn, :new))
    |> submit_form(%{session: %{email: user.email, password: "password"}})
    |> assert_response(
        redirect: user_path(conn, :edit, user)
      )
  end
end

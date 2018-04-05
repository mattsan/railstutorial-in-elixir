defmodule SampleWebApp.UserIndexTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  hound_session()

  alias SampleApp.{Accounts, Repo}
  alias SampleApp.Accounts.User

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        name: "foo",
        email: "foo@example.com",
        password: "password",
        password_confirmation: "password"
      })

    timestamp = NaiveDateTime.utc_now()
    password_digest = Bcrypt.hash_pwd_salt("password")

    entries =
      1..35
      |> Enum.map(fn n ->
        %{
          name: "user-#{n}",
          email: "user-#{n}@example.com",
          password_digest: password_digest,
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    Repo.insert_all(User, entries)

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

defmodule SampleWebApp.UserIndexTest do
  use SampleAppWeb.IntegrationCase, async: true

  alias SampleApp.Accounts

  def tap(conn, fun) do
    fun.(conn)
  end

  setup do
    {:ok, user} = Accounts.create_user(user_params("foo"))

    1..35 |> Enum.each(fn n ->
      Accounts.create_user(user_params("user-#{n}"))
    end)
    [user: user]
  end

  test "index including pagination", %{conn: conn, user: user} do
    conn
    |> log_in_as(user)
    |> get(user_path(conn, :index))
    |> assert_response(
        path: user_path(conn, :index),
        html: ~s[<ul class="pagination">]
      )
  end
end

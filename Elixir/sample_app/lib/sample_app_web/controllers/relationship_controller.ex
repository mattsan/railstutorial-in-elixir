defmodule SampleAppWeb.RelationshipController do
  use SampleAppWeb, :controller

  alias SampleApp.Accounts

  def create(conn, %{"relationship" => %{"followed_id" => followed_id}}) do
    user = Accounts.get_user!(followed_id)
    Accounts.follow(conn.assigns[:current_user], user)
    conn
    |> redirect(to: user_path(conn, :show, followed_id))
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    Accounts.unfollow(conn.assigns[:current_user], user)
    conn
    |> redirect(to: user_path(conn, :show, id))
  end
end

defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User

  def new(conn, _) do
    changeset = User.changeset(%User{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> render(:show, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:success, "Welcome to the Sample App")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, error_message(changeset))
        |> render(:new, changeset: changeset)
    end
  end

  defp error_message(%{errors: errors}) do
    case Enum.count(errors) do
      0 -> ""
      1 -> "The form contains an error."
      count -> "The form contains #{count} errors."
    end
  end
end

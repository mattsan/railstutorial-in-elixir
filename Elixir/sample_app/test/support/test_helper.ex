defmodule SampleAppWeb.TestHelper do
  alias SampleApp.{Accounts, Repo}
  alias SampleApp.Accounts.User

  def user_params(user_name) do
    %{
      name: "#{user_name}",
      email: "#{user_name}@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  def create_user(user_name) do
    {:ok, user} = Accounts.create_user(user_params(user_name))
    user
  end

  def create_users(user_names) do
    timestamp = NaiveDateTime.utc_now()
    password_digest = Bcrypt.hash_pwd_salt("password")

    entries =
      user_names
      |> Enum.map(fn user_name ->
        %{
          name: "#{user_name}",
          email: "#{user_name}@example.com",
          password_digest: password_digest,
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    Repo.insert_all(User, entries)
  end

  defmacro log_in_as(conn, user) do
    quote bind_quoted: [conn: conn, user: user] do
      user_params = %{
        "session" => %{
          "email" => user.email,
          "password" => "password",
          "remember_me" => "false"
        }
      }

      post(conn, SampleAppWeb.Router.Helpers.session_path(conn, :create), user_params)
    end
  end
end

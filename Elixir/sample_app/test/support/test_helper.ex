defmodule SampleAppWeb.TestHelper do
  alias SampleApp.{Accounts, Repo}
  alias SampleApp.Accounts.User

  def tag_string(tag, opts \\ []) do
    Phoenix.HTML.Tag.tag(tag, opts) |> Phoenix.HTML.safe_to_string()
  end

  def content_tag_string(tag, content, opts \\ []) do
    Phoenix.HTML.Tag.content_tag(tag, content, opts) |> Phoenix.HTML.safe_to_string()
  end

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

  defmacro is_logged_in?(conn) do
    quote bind_quoted: [conn: conn] do
      conn
      |> Plug.Conn.fetch_session()
      |> Plug.Conn.get_session(:user_id)
    end
  end
end

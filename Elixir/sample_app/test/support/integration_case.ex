defmodule SampleAppWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  defmodule Helper do
    def user_params(user_name) do
      %{
        name: "#{user_name}",
        email: "#{user_name}@example.com",
        password: "password",
        password_confirmation: "password"
      }
    end
  end

  using do
    quote do
      use SampleAppWeb.ConnCase
      use PhoenixIntegration

      import Helper

      def log_in_as(conn, user) do
        user_params = %{
          "session" => %{
            "email" => user.email,
            "password" => "password",
            "remember_me" => "false"
          }
        }

        post(conn, session_path(conn, :create), user_params)
      end

    end
  end
end

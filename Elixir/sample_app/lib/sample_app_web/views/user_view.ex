defmodule SampleAppWeb.UserView do
  use SampleAppWeb, :view

  def page_title(conn, action) do
    case action do
      :new -> "Sign up"
      _ -> nil
    end
  end
end

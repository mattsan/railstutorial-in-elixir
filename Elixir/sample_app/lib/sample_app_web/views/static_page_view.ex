defmodule SampleAppWeb.StaticPageView do
  use SampleAppWeb, :view

  def page_title(_conn, action) do
    case action do
      :help -> "Help"
      :contact -> "Contact"
      :about -> "About"
      _ -> nil
    end
  end
end

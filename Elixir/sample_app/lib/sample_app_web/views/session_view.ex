defmodule SampleAppWeb.SessionView do
  use SampleAppWeb, :view

  def page_title(_, :new), do: "Log in"
  def page_title(_, _), do: nil
end

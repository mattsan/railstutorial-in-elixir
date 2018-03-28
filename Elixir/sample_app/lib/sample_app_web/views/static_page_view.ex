defmodule SampleAppWeb.StaticPageView do
  use SampleAppWeb, :view

  def page_title(_, :help), do: "Help"
  def page_title(_, :contact), do: "Contact"
  def page_title(_, :about), do: "About"
  def page_title(_, _), do: nil
end

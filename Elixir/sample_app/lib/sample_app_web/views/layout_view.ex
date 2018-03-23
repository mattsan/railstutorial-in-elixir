defmodule SampleAppWeb.LayoutView do
  use SampleAppWeb, :view

  @title_base "Hello SampleApp!"

  def page_title(conn) do
    case conn.assigns[:title] do
      nil -> @title_base
      title -> "#{@title_base} | #{title}"
    end
  end
end

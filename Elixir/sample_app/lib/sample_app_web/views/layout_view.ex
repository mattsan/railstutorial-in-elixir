defmodule SampleAppWeb.LayoutView do
  use SampleAppWeb, :view

  @title_base "Hello SampleApp!"

  def page_title(conn) do
    title = with true <- function_exported?(view_module(conn), :page_title, 2),
                 do: apply(view_module(conn), :page_title, [conn, action_name(conn)])

    if title do
      "#{@title_base} | #{title}"
    else
      @title_base
    end
  end
end

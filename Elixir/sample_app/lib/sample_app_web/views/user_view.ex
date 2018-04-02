defmodule SampleAppWeb.UserView do
  use SampleAppWeb, :view
  import Scrivener.HTML

  @gravatar_uri %URI{scheme: "https", host: "secure.gravatar.com/avatar/"}

  def gravatar_for(user, opts \\ [size: 80]) when is_list(opts) do
    gravatar_id = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)
    size = Keyword.get(opts, :size)

    %URI{@gravatar_uri | path: gravatar_id, query: "s=#{size}"} |> to_string()
  end

  def page_title(_, :new), do: "Sign up"
  def page_title(_, :edit), do: "Edit your profile"
  def page_title(_, :index), do: "All users"
  def page_title(conn, :show), do: conn.assigns[:user].name
  def page_title(_, _), do: nil
end

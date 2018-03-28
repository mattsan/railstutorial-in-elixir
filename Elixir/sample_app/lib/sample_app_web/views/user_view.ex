defmodule SampleAppWeb.UserView do
  use SampleAppWeb, :view

  @gravatar_uri %URI{scheme: "https", host: "secure.gravatar.com/avatar/"}

  def gravatar_for(user, size \\ 80) do
    gravatar_id = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)

    %URI{@gravatar_uri | path: gravatar_id, query: "s=#{size}"} |> to_string()
  end

  def page_title(_, :new), do: "Sign up"
  def page_title(conn, :show), do: conn.assigns[:user].name
  def page_title(_, _), do: nil
end

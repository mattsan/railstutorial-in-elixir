defmodule SampleAppWeb.UserView do
  use SampleAppWeb, :view

  @gravatar_uri %URI{scheme: "https", host: "secure.gravatar.com/avatar/"}

  def gravatar_for(user, size \\ 80) do
    gravatar_id = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)

    %URI{@gravatar_uri | path: gravatar_id, query: "s=#{size}"} |> to_string()
  end

  def page_title(conn, action) do
    case action do
      :new ->
        "Sign up"
      :show ->
        conn.assigns[:user].name
      _ -> nil
    end
  end
end

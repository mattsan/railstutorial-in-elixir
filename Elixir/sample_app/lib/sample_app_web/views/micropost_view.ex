defmodule SampleAppWeb.MicropostView do
  use SampleAppWeb, :view
  import Scrivener.HTML

  defdelegate gravatar_for(user, opts), to: SampleAppWeb.UserView
end

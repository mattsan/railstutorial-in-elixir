defmodule SampleAppWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use SampleAppWeb.ConnCase
      use PhoenixIntegration
    end
  end
end

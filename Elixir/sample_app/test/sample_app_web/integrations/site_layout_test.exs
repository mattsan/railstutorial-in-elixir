defmodule SampleAppWeb.SiteLayoutTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  hound_session()

  test "layout links" do
    navigate_to(root_path(@endpoint, :home))

    assert current_path() == root_path(@endpoint, :home)

    assert page_title() == "Ruby on Rails Tutorial Sample App"

    assert find_element(:link_text, "SAMPLE APP") |> attribute_value("href") == root_url(@endpoint, :home)
    assert find_element(:link_text, "Home") |> attribute_value("href") == root_url(@endpoint, :home)
    assert find_element(:link_text, "Help") |> attribute_value("href") == static_page_url(@endpoint, :help)
    assert find_element(:link_text, "About") |> attribute_value("href") == static_page_url(@endpoint, :about)
    assert find_element(:link_text, "Contact") |> attribute_value("href") == static_page_url(@endpoint, :contact)

    find_element(:link_text, "Contact") |> click()

    assert page_title() == "Contact | Ruby on Rails Tutorial Sample App"
  end
end

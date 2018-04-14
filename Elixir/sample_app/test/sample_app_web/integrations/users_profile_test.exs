defmodule SampleAppWeb.UserProfileTest do
  use SampleAppWeb.ConnCase
  use Hound.Helpers

  alias SampleApp.Repo
  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost
  import SampleAppWeb.TestHelper

  hound_session()

  setup do
    user = create_user("foo")

    now = NaiveDateTime.utc_now()
    ten_minutes_ago = NaiveDateTime.add(now, -10 * 60)
    two_hour_ago = NaiveDateTime.add(now, -2 * 60 * 60)
    forty_two_days_ago = NaiveDateTime.add(now, -42 * 24 * 60 * 60)
    three_years_ago = NaiveDateTime.add(now, -3 * 365 * 24 * 60 * 60)

    entries =
      1..30
      |> Enum.map(fn _ ->
        %{
          user_id: user.id,
          content: Faker.Lorem.sentence(),
          inserted_at: forty_two_days_ago,
          updated_at: forty_two_days_ago
        }
      end)

    entries =
      [
        %{
          user_id: user.id,
          content: "I just ate an orange!",
          inserted_at: ten_minutes_ago,
          updated_at: ten_minutes_ago
        },
        %{
          user_id: user.id,
          content: "Check out the @tauday site by @mhartl: http://tauday.com",
          inserted_at: three_years_ago,
          updated_at: three_years_ago
        },
        %{
          user_id: user.id,
          content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk",
          inserted_at: two_hour_ago,
          updated_at: two_hour_ago
        },
        %{
          user_id: user.id,
          content: "Writing a short test",
          inserted_at: now,
          updated_at: now
        }
        | entries
      ]

    Repo.insert_all(Micropost, entries)

    [user: user]
  end

  test "profile display", %{user: user} do
    navigate_to(session_path(@endpoint, :new))

    fill_field({:id, "session_email"}, user.email)
    fill_field({:id, "session_password"}, "password")
    find_element(:tag, "button") |> submit_element()

    assert current_url() == user_url(@endpoint, :show, user)

    assert page_title() =~ user.name
    assert find_element(:tag, "h1") |> inner_text() == user.name

    assert find_element(:tag, "h1")
           |> find_within_element(:tag, "img")
           |> has_class?("gravatar")

    assert find_element(:class, "pagination") |> element_displayed?()

    Articles.list_microposts_paginated(%{}, user)
    |> Enum.each(fn micropost ->
        assert page_source() =~ micropost.content
      end)
  end
end

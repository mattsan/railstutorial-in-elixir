# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SampleApp.Repo.insert!(%SampleApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SampleApp.Repo
alias SampleApp.Accounts
alias SampleApp.Accounts.User
alias SampleApp.Articles
alias SampleApp.Articles.Micropost

create_microposts = &(
  1..&1 |> Enum.each(fn _ ->
    content = Faker.Lorem.sentence
    {:ok, %Micropost{}} =
      Articles.create_micropost(%{content: content}, &2)
  end)
)

{:ok, user} = Accounts.create_user(%{
  name: "Example User",
  email: "example@railstutorial.org",
  password: "password",
  password_confirmation: "password"
})

user
|> Ecto.Changeset.change(%{admin: true})
|> Repo.update()

create_microposts.(50, user)

1..99 |> Enum.each(fn n ->
  name = Faker.Name.name()
  email = "example-#{n}@railstutorial.org"
  password = "password"

  {:ok, %User{} = user} =
    Accounts.create_user(%{
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    })

  create_microposts.(50, user)
end)

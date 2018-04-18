defmodule SampleApp.Accounts.Relationship do
  use Ecto.Schema

  import Ecto.Changeset

  alias SampleApp.Accounts.User
  alias SampleApp.Accounts.Relationship

  schema "relationships" do
    belongs_to :follower, User, foreign_key: :follower_id
    belongs_to :followed, User, foreign_key: :followed_id
  end

  def changeset(%Relationship{} = relationship, %{follower: %User{}, followed: %User{}} = attrs) do
    relationship
    |> change(Map.take(attrs, [:follower, :followed]))
  end
end

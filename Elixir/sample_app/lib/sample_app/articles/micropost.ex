defmodule SampleApp.Articles.Micropost do
  use Ecto.Schema
  import Ecto.Changeset

  alias SampleApp.Accounts.User

  schema "microposts" do
    field :content, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(micropost, attrs) do
    micropost
    |> cast(attrs, [:user_id, :content])
    |> validate_required([:user_id, :content])
    |> validate_length(:content, max: 140)
  end
end

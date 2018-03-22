defmodule ToyApp.Articles.Micropost do
  use Ecto.Schema
  import Ecto.Changeset


  schema "microposts" do
    field :content, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(micropost, attrs) do
    micropost
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
  end
end

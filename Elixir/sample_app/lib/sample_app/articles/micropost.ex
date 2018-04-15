defmodule SampleApp.Articles.Micropost do
  use Ecto.Schema
  import Ecto.Changeset

  alias SampleApp.Accounts.User

  schema "microposts" do
    field :content, :string
    field :picture, :binary
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(micropost, attrs) do
    micropost
    |> cast(attrs, [:user_id, :content])
    |> validate_required([:user_id, :content])
    |> store_picture(attrs)
    |> validate_length(:content, max: 140)
  end

  defp store_picture(changeset, %{"picture" => %{content_type: "image/svg+xml", path: path}}) do
    case  File.read(path) do
      {:ok, content} ->
        put_change(changeset, :picture, <<"data:image/svg+xml;base64,", Base.encode64(content)::binary>>)
      _ ->
        changeset
    end
  end

  defp store_picture(changeset, %{"picture" => %{content_type: content_type, path: path}}) do
    case  System.cmd("convert", [path, "-resize", "400x400>", "jpg:-"]) do
      {content, 0} ->
        put_change(changeset, :picture, <<"data:", content_type::binary, ";base64,", Base.encode64(content)::binary>>)
      _ ->
        changeset
    end
  end

  defp store_picture(changeset, _), do: changeset
end

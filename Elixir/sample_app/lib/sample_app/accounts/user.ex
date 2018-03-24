defmodule SampleApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt
  import Bcrypt.Base

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_digest, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_length(:name, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, @valid_email_regex)
    |> validate_confirmation(:password)
    |> downcase(:email)
    |> unsafe_validate_unique([:email], SampleApp.Repo)
    |> digest_password()
  end

  defp downcase(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset
      value ->
        put_change(changeset, field, String.downcase(value))
    end
  end

  defp digest_password(changeset) do
    case get_field(changeset, :password) do
      nil ->
        changeset
      password ->
        password_digest = hash_password(password, gen_salt())
        put_change(changeset, :password_digest, password_digest)
    end
  end
end

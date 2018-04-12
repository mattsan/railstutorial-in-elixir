defmodule SampleApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SampleApp.Repo

  alias SampleApp.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> order_by(:id)
    |> Repo.all()
  end

  def list_users_paginated(params) do
    User
    |> order_by(:id)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_with_microposts!(id) do
    User
    |> preload(:microposts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs, [:name, :email])
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_user_by(params) when is_list(params) do
    Repo.get_by(User, params)
  end

  def count_users do
    User
    |> select([u], count(u.id))
    |> Repo.one()
  end

  defp new_token do
    16 |> :crypto.strong_rand_bytes() |> Base.url_encode64()
  end

  def remember_user(%User{} = user) do
    remember_token = new_token()
    remember_digest = Bcrypt.hash_pwd_salt(remember_token)
    Repo.update(Ecto.Changeset.change(user, %{remember_digest: remember_digest}))
    remember_token
  end

  def forget_user(%User{} = user) do
    user && Repo.update(Ecto.Changeset.change(user, %{remember_digest: nil}))
  end

  def authenticated?(%User{} = user, remember_token) do
    user.remember_digest != nil && Bcrypt.verify_pass(remember_token, user.remember_digest)
  end
end

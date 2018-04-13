defmodule SampleApp.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias SampleApp.Repo

  alias SampleApp.Articles.Micropost

  @doc """
  Returns the list of microposts.

  ## Examples

      iex> list_microposts()
      [%Micropost{}, ...]

  """
  def list_microposts do
    Micropost
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_microposts_paginated(params, user) do
    user
    |> Ecto.assoc(:microposts)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single micropost.

  Raises `Ecto.NoResultsError` if the Micropost does not exist.

  ## Examples

      iex> get_micropost!(123)
      %Micropost{}

      iex> get_micropost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_micropost!(id), do: Repo.get!(Micropost, id)

  @doc """
  Creates a micropost.

  ## Examples

      iex> create_micropost(%{field: value})
      {:ok, %Micropost{}}

      iex> create_micropost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_micropost(attrs \\ %{}, user) do
    %Micropost{}
    |> build_assoc(user)
    |> Micropost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a micropost.

  ## Examples

      iex> update_micropost(micropost, %{field: new_value})
      {:ok, %Micropost{}}

      iex> update_micropost(micropost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_micropost(%Micropost{} = micropost, attrs) do
    micropost
    |> Micropost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Micropost.

  ## Examples

      iex> delete_micropost(micropost)
      {:ok, %Micropost{}}

      iex> delete_micropost(micropost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_micropost(%Micropost{} = micropost) do
    Repo.delete(micropost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking micropost changes.

  ## Examples

      iex> change_micropost(micropost)
      %Ecto.Changeset{source: %Micropost{}}

  """
  def change_micropost(%Micropost{} = micropost) do
    Micropost.changeset(micropost, %{})
  end

  defp build_assoc(microposts, user) do
    Ecto.build_assoc(user, :microposts, microposts)
  end
end

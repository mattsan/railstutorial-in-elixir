defmodule SampleApp.Repo.Migrations.AddIndexToUsersEmail do
  use Ecto.Migration

  def change do
    unique_index(:users, :email)
  end
end

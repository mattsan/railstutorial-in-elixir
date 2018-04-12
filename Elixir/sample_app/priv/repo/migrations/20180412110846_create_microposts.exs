defmodule SampleApp.Repo.Migrations.CreateMicroposts do
  use Ecto.Migration

  def change do
    create table(:microposts) do
      add :user_id, references(:users), null: false
      add :content, :text

      timestamps()
    end

    create index(:microposts, [:user_id, :inserted_at])
  end
end

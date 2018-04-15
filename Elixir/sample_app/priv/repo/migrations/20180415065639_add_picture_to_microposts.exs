defmodule SampleApp.Repo.Migrations.AddPictureToMicroposts do
  use Ecto.Migration

  def change do
    alter table(:microposts) do
      add :picture, :binary
    end
  end
end

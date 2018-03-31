defmodule SampleApp.Repo.Migrations.AddRememberDigestToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :remember_digest, :string
    end
  end
end

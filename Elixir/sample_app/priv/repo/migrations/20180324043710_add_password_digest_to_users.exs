defmodule SampleApp.Repo.Migrations.AddPasswordDigestToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_digest, :string
    end
  end
end

defmodule Learn.Repo.Migrations.RelatePollToUsers do
  use Ecto.Migration

  def change do
    alter table(:polls) do
      add :user_id, references(:users)
    end
    create index(:polls, [ :user_id ])
  end
end

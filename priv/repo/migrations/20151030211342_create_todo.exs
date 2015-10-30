defmodule TodoApi.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :content, :string, null: false
      add :completed_at, :datetime
      add :user_id, references(:users), null: false

      timestamps
    end

    create index(:todos, [:user_id])
  end
end

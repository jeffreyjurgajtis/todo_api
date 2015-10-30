defmodule TodoApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :crypted_password, :string, null: false
      add :authentication_token, :string, null: false

      timestamps
    end

    create unique_index(:users, [:email], unique: true)
    create unique_index(:users, [:authentication_token], unique: true)
  end
end

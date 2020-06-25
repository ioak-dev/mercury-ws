defmodule Appnamehere.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :user_id, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:users, [:user_id])
  end
end

defmodule Mercury.Repo.Migrations.CreatePersonmessages do
  use Ecto.Migration

  def change do
    create table(:personmessages) do
      add :sender, :integer
      add :receiver, :integer
      add :content, :text

      timestamps()
    end

  end
end

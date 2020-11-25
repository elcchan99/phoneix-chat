defmodule Chat.Repo.Migrations.UpdateMessagesTable do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room, :string, default: "lobby"
    end
  end
end

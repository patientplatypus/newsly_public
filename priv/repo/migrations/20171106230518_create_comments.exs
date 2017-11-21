defmodule Newsly.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :body, :string
      add :user, :string
      add :upvotes, :integer
      add :downvotes, :integer
      add :flaggedcount, :integer
      add :article_id, references(:article, on_delete: :nothing)
      add :userId, :integer

      timestamps()
    end

    create index(:comment, [:article_id])
  end
end

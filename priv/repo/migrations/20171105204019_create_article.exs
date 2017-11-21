defmodule Newsly.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:article) do
      add :user, :string
      add :articleurl, :string
      add :articletitle, :string
      add :upvotes, :integer
      add :downvotes, :integer
      add :flaggedcount, :integer
      add :userId, :integer

      timestamps()
    end

  end
end

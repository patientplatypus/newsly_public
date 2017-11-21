defmodule Newsly.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :profileImageURL, :string
      add :userupvotes, :integer
      add :userdownvotes, :integer
      add :userflaggedcount, :integer


      timestamps()
    end

  end
end


defmodule Newsly.Articles do
  use Ecto.Schema
  import Ecto.Changeset
  alias Newsly.Articles
  # use Newsly.Schema

@derive {Poison.Encoder, only: [:articletitle, :articleurl, :downvotes, :flaggedcount, :upvotes, :user, :userId, :id]}
  schema "article" do
    field :articletitle, :string
    field :articleurl, :string
    field :downvotes, :integer
    field :flaggedcount, :integer
    field :upvotes, :integer
    field :user, :string
    field :userId, :integer
    has_many :comment, Newsly.Comments, on_delete: :delete_all,  foreign_key: :article_id
    timestamps()
  end

  @doc false
  def changeset(%Articles{} = articles, attrs) do
    articles
    |> cast(attrs, [:user, :userId, :articleurl, :articletitle, :upvotes, :downvotes, :flaggedcount])
    |> validate_required([:user, :userId, :articleurl, :articletitle, :upvotes, :downvotes, :flaggedcount])
  end
end

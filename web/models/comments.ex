defmodule Newsly.Comments do
  use Newsly.Web, :model

@derive {Poison.Encoder, only: [:body, :user, :upvotes, :downvotes, :flaggedcount, :article_id, :id, :userId]}
  schema "comment" do
    field :body, :string
    field :user, :string
    field :upvotes, :integer
    field :downvotes, :integer
    field :flaggedcount, :integer
    field :userId, :integer
    belongs_to :article, Newsly.Articles
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :user, :userId, :upvotes, :downvotes, :flaggedcount, :id])
    |> validate_required([:body, :user, :userId, :upvotes, :downvotes, :flaggedcount, :id])
  end
end

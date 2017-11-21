defmodule Newsly.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Newsly.User

@derive {Poison.Encoder, only: [:password, :username, :profileImageURL, :userupvotes, :userdownvotes, :userflaggedcount]}
  schema "users" do
    field :password, :string
    field :username, :string
    field :profileImageURL, :string
    field :userupvotes, :integer
    field :userdownvotes, :integer
    field :userflaggedcount, :integer

    timestamps()
  end

  @doc false
  #profileImageURL is not necessary so it will not be required for changeset.
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :profileImageURL, :userupvotes, :userdownvotes, :userflaggedcount])
    |> validate_required([:username, :password, :profileImageURL, :userupvotes, :userdownvotes, :userflaggedcount])
  end
end

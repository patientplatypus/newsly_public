defmodule Newsly.CommentsTest do
  use Newsly.ModelCase

  alias Newsly.Comments

  @valid_attrs %{body: "some body", downvotes: 42, flaggedcount: 42, upvotes: 42, user: "some user"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comments.changeset(%Comments{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comments.changeset(%Comments{}, @invalid_attrs)
    refute changeset.valid?
  end
end

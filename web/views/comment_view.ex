defmodule Newsly.CommentsView do
  use Newsly.Web, :view

  def render("show.json", %{comments: comments}) do
    render_one(comments, Newsly.CommentsView, "comment.json")
  end

  def render("comment.json", %{comments: comments}) do
    Map.take(comments, ~w(user body article_id upvotes downvotes flaggedcount id)a)
  end

end

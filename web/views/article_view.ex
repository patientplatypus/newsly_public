defmodule Newsly.ArticleAPIView do
  use Newsly.Web, :view

  def render("index.json", %{articles: articles}) do
    render_many(articles, Newsly.ArticleAPIView, "article.json")
  end

  def render("show.json", %{article: article}) do
    render_one(article, Newsly.ArticleAPIView, "article.json")
  end

  def render("article.json", %{article_api: article_api}) do
    %{article: article_api,
      comments: render_many(article_api.comment, Newsly.CommentsView, "show.json") }
  end
end

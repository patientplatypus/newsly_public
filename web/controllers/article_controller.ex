defmodule Newsly.ArticleAPIController do
  use Newsly.Web, :controller
  alias Newsly.{Repo, Articles, Comments}
  plug :put_view, Newsly.ArticleAPIView

  def index(conn, _params) do
    articles = Repo.all(from a in Articles, order_by: [desc: a.id])
      |> Repo.preload(:comment)
    render conn, "index.json", articles: articles
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Articles, id)
      |> Repo.preload(:comment)
    render conn, "show.json", article: article
  end

end

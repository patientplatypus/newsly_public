defmodule Newsly.CommentsController do
  use Newsly.Web, :controller
  plug :put_view, Newsly.CommentsView

  alias Newsly.Comments

  def index(conn, _params) do
    comment = Repo.all(Comments)
    render(conn, "index.html", comment: comment)
  end

  def new(conn, _params) do
    changeset = Comments.changeset(%Comments{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comments" => comments_params}) do
    changeset = Comments.changeset(%Comments{}, comments_params)

    case Repo.insert(changeset) do
      {:ok, comments} ->
        conn
        |> put_flash(:info, "Comments created successfully.")
        |> redirect(to: comments_path(conn, :show, comments))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comments = Repo.get!(Comments, id)
    render(conn, "show.html", comments: comments)
  end

  def edit(conn, %{"id" => id}) do
    comments = Repo.get!(Comments, id)
    changeset = Comments.changeset(comments)
    render(conn, "edit.html", comments: comments, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comments" => comments_params}) do
    comments = Repo.get!(Comments, id)
    changeset = Comments.changeset(comments, comments_params)

    case Repo.update(changeset) do
      {:ok, comments} ->
        conn
        |> put_flash(:info, "Comments updated successfully.")
        |> redirect(to: comments_path(conn, :show, comments))
      {:error, changeset} ->
        render(conn, "edit.html", comments: comments, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comments = Repo.get!(Comments, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comments)

    conn
    |> put_flash(:info, "Comments deleted successfully.")
    |> redirect(to: comments_path(conn, :index))
  end
end

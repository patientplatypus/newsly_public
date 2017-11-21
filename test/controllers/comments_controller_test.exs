defmodule Newsly.CommentsControllerTest do
  use Newsly.ConnCase

  alias Newsly.Comments
  @valid_attrs %{body: "some body", downvotes: 42, flaggedcount: 42, upvotes: 42, user: "some user"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, comments_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing comment"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, comments_path(conn, :new)
    assert html_response(conn, 200) =~ "New comments"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, comments_path(conn, :create), comments: @valid_attrs
    comments = Repo.get_by!(Comments, @valid_attrs)
    assert redirected_to(conn) == comments_path(conn, :show, comments.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, comments_path(conn, :create), comments: @invalid_attrs
    assert html_response(conn, 200) =~ "New comments"
  end

  test "shows chosen resource", %{conn: conn} do
    comments = Repo.insert! %Comments{}
    conn = get conn, comments_path(conn, :show, comments)
    assert html_response(conn, 200) =~ "Show comments"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, comments_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    comments = Repo.insert! %Comments{}
    conn = get conn, comments_path(conn, :edit, comments)
    assert html_response(conn, 200) =~ "Edit comments"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    comments = Repo.insert! %Comments{}
    conn = put conn, comments_path(conn, :update, comments), comments: @valid_attrs
    assert redirected_to(conn) == comments_path(conn, :show, comments)
    assert Repo.get_by(Comments, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    comments = Repo.insert! %Comments{}
    conn = put conn, comments_path(conn, :update, comments), comments: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit comments"
  end

  test "deletes chosen resource", %{conn: conn} do
    comments = Repo.insert! %Comments{}
    conn = delete conn, comments_path(conn, :delete, comments)
    assert redirected_to(conn) == comments_path(conn, :index)
    refute Repo.get(Comments, comments.id)
  end
end

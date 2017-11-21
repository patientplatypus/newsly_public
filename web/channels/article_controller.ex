defmodule Newsly.ArticleController do
  import Ecto.Query
  import Ecto.Changeset
  alias Newsly.{Repo, User, Articles, Comments, RoomChannel}

  def new(username, password, articletitle, articleurl, socket) do
    IO.puts "1"
    target_records_title =
      from(a in Articles, where: a.articletitle == ^articletitle)
      |> Repo.one()
    IO.puts "2"
    target_records_url =
      from(a in Articles, where: a.articleurl == ^articleurl)
      |> Repo.one()
    IO.puts "3"
    target_records_user =
       from(u in User, where: [username: ^username, password: ^password])
          |> Repo.one()
    IO.puts "4"
    IO.inspect target_records_user
    userId = Map.get(target_records_user, :id)
    IO.inspect userId


    cond do
      target_records_url==nil && target_records_title==nil ->
        IO.puts "5"
        Repo.insert(%Articles{articletitle: articletitle, articleurl: articleurl, downvotes: 0, flaggedcount: 0, upvotes: 0, user: username, userId: userId})
        IO.puts "6"
        payload = %{articletitle: articletitle, articleurl: articleurl}
        IO.puts "7"
        RoomChannel.newArticleReturn(payload, socket)
      true ->
        payload = %{error: 'url or title already in database'}
        RoomChannel.newArticleReturn(payload, socket)
    end

  end

  def retrieve(articleurl, articletitle, socket) do
    retrieverecord = from(a in Articles, where: a.articletitle == ^articletitle, where: a.articleurl == ^articleurl) |> Repo.one() |> Repo.preload(:comment)
    IO.puts "inside retrieve in article controller"
    IO.puts "value of retrieverecord: "
    IO.inspect retrieverecord
    RoomChannel.broadcastArticleReturn(retrieverecord, socket)
  end

  def voting(type, articleurl, articletitle, user, socket) do
    currentArticle = Repo.one(
      from a in Articles,
      where: [articletitle: ^articletitle, articleurl: ^articleurl]
    )

    userId = Map.get(currentArticle, :userId)

    currentUser = Repo.one(
      from u in User,
      where: [id: ^userId]
    )

    upvotes   = Map.get(currentArticle, :upvotes)
    downvotes = Map.get(currentArticle, :downvotes)
    flagvotes = Map.get(currentArticle, :flaggedcount)

    password        = Map.get(currentUser, :password)
    username        = Map.get(currentUser, :username)
    profileImageURL = Map.get(currentUser, :profileImageURL)
    userupvotes     = Map.get(currentUser, :userupvotes)
    userdownvotes   = Map.get(currentUser, :userdownvotes)
    userflaggedcount   = Map.get(currentUser, :userflaggedcount)

    cond do
      userupvotes == nil ->
        userupvotes = 0
      userdownvotes == nil ->
        userdownvotes = 0
      userflaggedcount == nil ->
        userflaggedcount = 0
      profileImageURL == nil ->
        profileImageURL = "empty"
      true ->
    end

    # probably could get rid of this repitition here, not sure how at the moment
    cond do
      type == "upvote" ->
        upvotes = upvotes + 1
        articles_changeset = Articles.changeset(currentArticle, %{
          upvotes: upvotes, user: user, articleurl: articleurl, articletitle: articletitle, downvotes: downvotes, flaggedcount: flagvotes
        })

        IO.puts "value of userupvotes"
        IO.inspect userupvotes

        userupvotes = userupvotes + 1

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        Repo.update(user_changeset)

        case Repo.update(articles_changeset) do
           {:ok, record} -> RoomChannel.articleUpdateReturn(record, socket)
        end

      type == "downvote" ->
        downvotes = downvotes + 1
        articles_changeset = Articles.changeset(currentArticle, %{
          upvotes: upvotes, user: user, articleurl: articleurl, articletitle: articletitle, downvotes: downvotes, flaggedcount: flagvotes
        })

        userdownvotes = userdownvotes + 1

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        Repo.update(user_changeset)

        case Repo.update(articles_changeset) do
           {:ok, record} -> RoomChannel.articleUpdateReturn(record, socket)
        end
      type == "flagvote" ->
        flagvotes = flagvotes + 1

        userflaggedcount = userflaggedcount + 1

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        Repo.update(user_changeset)

        articles_changeset = Articles.changeset(currentArticle, %{
          upvotes: upvotes, user: user, articleurl: articleurl, articletitle: articletitle, downvotes: downvotes, flaggedcount: flagvotes
        })

        case Repo.update(articles_changeset) do
           {:ok, record} -> RoomChannel.articleUpdateReturn(record, socket)
        end
    end

  end

end

defmodule Newsly.RoomChannel do
  use Phoenix.Channel
  import Ecto.Query
  import Ecto.Changeset
  alias Newsly.SignonController
  alias Newsly.ArticleController
  alias Newsly.{Repo, Articles, User}
  alias Newsly.CommentController


  def join("room:lobby", payload, socket) do
    IO.puts "inside room:lobby channel handler"
    {:ok, socket}
  end

  def join("room:broadcast", payload, socket) do
    IO.puts "inside room:lobby channel handler"
    {:ok, socket}
  end

  def leave(room_id, _user_id) do
    IO.puts "inside the leave channel handler"
  end

  def join("room:" <> comment_room_id, payload, socket) do
    IO.puts "inside room: {private/error} channel handler"
    {:ok, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_in("signup", %{"username" => username, "password"=>password}, socket) do
    SignonController.signup(username, password, socket)
    {:noreply, socket}
  end

  def handle_in("login", %{"username" => username, "password"=>password}, socket) do
    SignonController.login(username, password, socket)
    {:noreply, socket}
  end

  def handle_in("newArticle", %{"username" => username, "password"=>password, "articletitle"=>articletitle, "articleurl"=>articleurl}, socket) do
    ArticleController.new(username, password, articleurl, articletitle, socket)
    {:noreply, socket}
  end

  def handle_in("broadcastArticles", %{"payload"=>payload}, socket) do
    IO.puts "inside broadcastArticles handle_in"
    IO.inspect payload
    IO.inspect payload["articletitle"]
    articletitle = payload["articletitle"]
    articleurl = payload["articleurl"]
    IO.inspect articletitle
    IO.inspect articleurl
    ArticleController.retrieve(articleurl, articletitle, socket)
    # ArticleController.retrieve(socket)
    {:noreply, socket}
  end

  def signOnControllerReturn(payload, socket) do
    push socket, "signonreturn", payload
  end

  def newArticleReturn(payload, socket) do
    IO.puts "inside newArticleReturn"
    push socket, "newarticlereturn", payload
  end

  def articleUpdateReturn(payload, socket) do
    IO.puts "inside articleUpdateReturn"
    IO.puts "value of payload"
    IO.inspect payload
    push socket, "articleUpdateReturn", payload
  end

  def commentUpdateReturn(payload, socket) do
    IO.puts "inside commentUpdateReturn"
    IO.puts "value of payload"
    IO.inspect payload
    push socket, "commentUpdateReturn", payload
  end

  def broadcastArticleReturn(payload, socket) do
    IO.puts "inside broadcastArticleReturn"
    IO.puts "value of payload is "
    IO.inspect payload
    broadcast! socket, "broadcastArticleReturn", payload
  end

  def handle_in("broadcastCommentVote", %{"payload" => payload}, socket) do
    IO.puts "inside broadcastCommentVote"
    IO.puts "value of payload"
    IO.inspect payload


    userId = payload["userId"]

    IO.puts "userId"
    IO.inspect userId

    user =
      from(u in User, where: [id: ^userId])
          |> Repo.one()

    users = Repo.all(User)

    IO.puts "value of user"
    IO.inspect user

    IO.puts "value of all users"
    IO.inspect users

    userupvotes      = Map.get(user, :userupvotes)
    userdownvotes    = Map.get(user, :userdownvotes)
    userflaggedcount = Map.get(user, :userflaggedcount)
    username         = Map.get(user, :username)

    sanitizeduser = %{userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount, username: username}

    updatedpayload = %{sanitizeduser: sanitizeduser, payload: payload}


    broadcast! socket, "broadcastCommentVote", updatedpayload
    {:noreply, socket}
  end


  def handle_in("broadcastArticleVote", %{"payload" => payload}, socket) do

    userId = payload["userId"]

    user =
      from(u in User, where: [id: ^userId])
          |> Repo.one()

    userupvotes      = Map.get(user, :userupvotes)
    userdownvotes    = Map.get(user, :userdownvotes)
    userflaggedcount = Map.get(user, :userflaggedcount)
    username         = Map.get(user, :username)

    sanitizeduser = %{userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount, username: username}

    updatedpayload = %{sanitizeduser: sanitizeduser, payload: payload}

    broadcast! socket, "broadcastVoteReturn", updatedpayload
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end



  def handle_in("articleupvote", %{"article" => article}, socket) do
    articletitle = article["articletitle"]
    articleurl = article["articleurl"]
    user = article["user"]
    type = "upvote"
    ArticleController.voting(type, articleurl, articletitle, user, socket)
    {:noreply, socket}
  end

  def handle_in("articledownvote", %{"article" => article}, socket) do
    articletitle = article["articletitle"]
    articleurl = article["articleurl"]
    user = article["user"]
    type = "downvote"
    ArticleController.voting(type, articleurl, articletitle, user, socket)
    {:noreply, socket}
  end

  def handle_in("articleflagvote", %{"article" => article}, socket) do
    articletitle = article["articletitle"]
    articleurl = article["articleurl"]
    user = article["user"]
    type = "flagvote"
    ArticleController.voting(type, articleurl, articletitle, user, socket)
    {:noreply, socket}
  end



  def handle_in("commentupvote", %{"comment" => comment}, socket) do
    IO.puts "***COMMENT***"
    IO.inspect comment
    commentinner = comment["comment"]
    upvotes = commentinner["user"]
    downvotes = commentinner["downvotes"]
    flaggedcount = commentinner["flaggedcount"]
    id = commentinner["id"]
    IO.puts "value of id in handler"
    IO.inspect id
    type = "upvote"
    CommentController.voting(type, upvotes, downvotes, flaggedcount, id, socket)
    {:noreply, socket}
  end

  def handle_in("commentdownvote", %{"comment" => comment}, socket) do
    IO.puts "***COMMENT***"
    IO.inspect comment
    commentinner = comment["comment"]
    upvotes = commentinner["user"]
    downvotes = commentinner["downvotes"]
    flaggedcount = commentinner["flaggedcount"]
    id = commentinner["id"]
    IO.puts "value of id in handler"
    IO.inspect id
    type = "downvote"
    CommentController.voting(type, upvotes, downvotes, flaggedcount, id, socket)
    {:noreply, socket}
  end

  def handle_in("commentflagvote", %{"comment" => comment}, socket) do
    IO.puts "***COMMENT***"
    IO.inspect comment
    commentinner = comment["comment"]
    upvotes = commentinner["user"]
    downvotes = commentinner["downvotes"]
    flaggedcount = commentinner["flaggedcount"]
    id = commentinner["id"]
    IO.puts "value of id in handler"
    IO.inspect id
    type = "flagvote"
    CommentController.voting(type, upvotes, downvotes, flaggedcount, id, socket)
    {:noreply, socket}
  end






  def handle_in("addComment", %{"articleid" => articleid , "message" => message, "user" => user}, socket) do
    IO.puts "inside addComment handle_in"
    IO.inspect message
    IO.inspect articleid
    IO.inspect user
    CommentController.addComment(articleid, message, user, socket)
    {:noreply, socket}
  end

  def broadcastCommentReturn(payload, socket) do
    IO.puts "inside broadcastCommentReturn"
    IO.puts "value of payload is "
    IO.inspect payload
    # IO.puts "value of id in payload"
    # payload_id = payload["id"]
    # IO.inspect payload_id
    broadcast! socket, "broadcastCommentReturn", payload
  end


end

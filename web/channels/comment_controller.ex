defmodule Newsly.CommentController do
  import Ecto.Query
  alias Newsly.{Repo, Articles, Comments, RoomChannel, User}

  def addComment(articleid, message, user, socket) do

    article = Repo.get(Articles, articleid)
    |> Repo.preload(:comment)

    target_records_user =
       from(u in User, where: [username: ^user])
          |> Repo.one()

    userId = Map.get(target_records_user, :id)

    comment = Ecto.build_assoc(article, :comment, %{body: message, user: user, upvotes: 0, downvotes: 0, flaggedcount: 0, userId: userId})

    Repo.insert(comment)

    comments = Repo.all(Comments)
              |>Repo.preload(:article)

    IO.puts "****COMMENTS*****"
    IO.inspect comments

    returncomment = Repo.one(from c in Comments, where: [body: ^message, user: ^user], order_by: [desc: c.id], limit: 1)
    # here I am returning the comment from the database and getting the last item
    # I am doing this so I can return the comment id, but in case there are several with the same
    # variables, I just want the id of the latest one.

    IO.puts "****RETURNCOMMENT*****"
    IO.inspect returncomment

    # RoomChannel.broadcastCommentReturn(comment, socket)
    RoomChannel.broadcastCommentReturn(returncomment, socket)

  end

  def voting(type, upvotes, downvotes, flaggedcount, id, socket) do
    IO.puts 'value of id'
    IO.inspect id
    allcomments = Repo.all(Comments)
    IO.puts "allcomments"
    IO.inspect allcomments
    commentchange = Repo.one(from c in Comments, where: [id: ^id])
    IO.puts "value of commentchange"
    IO.inspect commentchange

    userId = Map.get(commentchange, :userId)

    currentUser = Repo.one(
      from u in User,
      where: [id: ^userId]
    )

    IO.puts "CURRENTUSER"
    IO.inspect currentUser

    upvotes   = Map.get(commentchange, :upvotes)
    downvotes = Map.get(commentchange, :downvotes)
    flaggedcount = Map.get(commentchange, :flaggedcount)
    body      = Map.get(commentchange, :body)
    user      = Map.get(commentchange, :user)

    password        = Map.get(currentUser, :password)
    username        = Map.get(currentUser, :username)
    profileImageURL = Map.get(currentUser, :profileImageURL)
    userupvotes     = Map.get(currentUser, :userupvotes)
    userdownvotes   = Map.get(currentUser, :userdownvotes)
    userflaggedcount   = Map.get(currentUser, :userflaggedcount)

    IO.puts "*******value of userupvotes*****"
    IO.inspect userupvotes

    cond do
      flaggedcount == nil ->
        flaggedcount = 0
      downvotes == nil ->
        downvotes = 0
      upvotes == nil ->
        upvotes = 0
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


    cond do
      type == "upvote" ->
        upvotes = upvotes + 1
        comment_changeset = Comments.changeset(commentchange, %{
          body: body, user: user, upvotes: upvotes, downvotes: downvotes, flaggedcount: flaggedcount
        })


        userupvotes = userupvotes + 1

        IO.puts "userupvotes"
        IO.inspect userupvotes

        testObj = %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount}

        IO.puts "testObj"
        IO.inspect testObj

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        IO.puts "&&&&&&&&&&&&&&&&"
        Repo.update(user_changeset)
        IO.puts "&&&&&&&&&&&&&&&&"
        # checkusers = Repo.all(User)
        #
        # IO.puts "check all the users we should have just changed"
        # IO.inspect checkusers

        case Repo.update(comment_changeset) do
           {:ok, record} -> RoomChannel.commentUpdateReturn(record, socket)
        end
      type == "downvote" ->
        downvotes = downvotes + 1
        comment_changeset = Comments.changeset(commentchange, %{
          body: body, user: user, upvotes: upvotes, downvotes: downvotes, flaggedcount: flaggedcount
        })


        userdownvotes = userdownvotes + 1

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        Repo.update(user_changeset)


        case Repo.update(comment_changeset) do
           {:ok, record} -> RoomChannel.commentUpdateReturn(record, socket)
        end
      type == "flagvote" ->
        flaggedcount = flaggedcount + 1
        comment_changeset = Comments.changeset(commentchange, %{
          body: body, user: user, upvotes: upvotes, downvotes: downvotes, flaggedcount: flaggedcount
        })


        userflaggedcount = userflaggedcount + 1

        user_changeset = User.changeset(currentUser, %{password: password, username: username, profileImageURL: profileImageURL, userupvotes: userupvotes, userdownvotes: userdownvotes, userflaggedcount: userflaggedcount})

        Repo.update(user_changeset)


        case Repo.update(comment_changeset) do
           {:ok, record} -> RoomChannel.commentUpdateReturn(record, socket)
        end
    end
  end

end

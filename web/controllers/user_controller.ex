defmodule Newsly.UserController do
  use Newsly.Web, :controller
  alias Newsly.{Repo, Articles, Comments, User}
  # plug :put_view, Newsly.UserView

  def index(conn, params) do
    IO.puts "&&&&&&&& INSIDE INDEX GET REQUEST &&&&&&&&"
    IO.puts "inside UserController"
    IO.puts "params"
    IO.inspect params
    password = params["password"]
    # password = Map.get(params, :password)
    # username = Map.get(params, :username)
    username = params["username"]
    IO.puts "password"
    IO.inspect password
    user =
      from(u in User, where: [username: ^username, password: ^password])
      |> Repo.one()
    IO.puts "user in index; "
    conn
      |> put_status(201)
      |> json(user)
    # IO.inspect user
    # render conn, "index.json", user: user
  end

end

defmodule Newsly.PageController do
  use Newsly.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end

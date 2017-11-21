defmodule Newsly.HealthCheck do
  use Newsly.Web, :controller

  def index(conn, _params) do
    IO.puts "INSIDE HEALTHCHECK"
    send_resp(conn, 200, "")
  end


end

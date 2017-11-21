defmodule Newsly.UploadController do
  use Newsly.Web, :controller
  alias Newsly.{User}

  def create(conn, %{"image" => image_base64, "username"=>username, "password"=>password}) do
    s3_url = Newsly.AssetStore.upload_image(image_base64)

    # IO.puts "username"
    # IO.inspect username
    # IO.puts "password"
    # IO.inspect password

    cond do
      username != nil && password != nil ->
        target_records = from(u in User, where: [username: ^username, password: ^password]) |> Repo.one()
        cond do target_records != nil ->
          user_changeset = User.changeset(target_records,%{username: username, password: password, profileImageURL: s3_url})
          Repo.update(user_changeset)
        end
    end


    conn
    |> put_status(201)
    |> json(%{"url" => s3_url})
  end
end

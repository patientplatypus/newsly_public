defmodule Newsly.AssetStore do

  @moduledoc """
 Responsible for accepting files and uploading them to an asset store.
 """

 alias ExAws.S3

 @doc """
 Accepts a base64 encoded image and uploads it to S3.

 ## Examples

     iex> upload_image(...)
     "https://image_bucket.s3.amazonaws.com/dbaaee81609747ba82bea2453cc33b83.png"

 """
 #@spec is for type safety - says here that upload_image and s3_url must be strings (I think)
 @spec upload_image(String.t) :: s3_url :: String.t
 def upload_image(image_base64) do

   bucket_name = System.get_env("BUCKET_NAME")
   access_key  = System.get_env("AWS_ACCESS_KEY_ID")
   secret_key  = System.get_env("AWS_SECRET_ACCESS_KEY")

   # Decode the image
   {:ok, image_binary} = Base.decode64(image_base64)

   IO.puts "value of image binary"
   IO.inspect image_binary

   # Generate a unique filename
   filename =
     image_binary
     |> image_extension()
     |> unique_filename()

    IO.puts "value of created filename:"
    IO.inspect filename

   # Upload to S3

   IO.puts "**********"
   IO.puts "before S3 push"
   IO.puts "**********"

   {:ok, response} =
     S3.put_object(bucket_name, filename, image_binary)
     |> ExAws.request()

   IO.puts "**********"
   IO.puts "value of :ok"
   IO.puts "**********"
   IO.inspect response
   # IO.puts response
   IO.puts "**********"


   IO.puts "**********"
   IO.puts "after S3 push"
   IO.puts "**********"

  #  case S3.put_object(bucket_name, filename, image_binary)
  #  |> ExAws.request() do
  #    {:ok, response} ->
  #      IO.puts "response ok"
  #      IO.inspect response
  #    {:error, error} ->
  #      IO.puts "error boo"
  #      IO.inspect error
  #  end


    #  Work on deleting item:
    #  Not implemented for now, but the way that I would approach the problem :
    #  Send over the username from the upload controller
    #  Find the user object associated with the user, and see if profileImageURL is empty
    #  If not run the following command:
    #  ExAws.S3.delete_object("bucket-name", "file-name") |> ExAws.request()
    #  (You could back out the filename by string search on the url in profileImageURL)
    #  In production application this would of course be necessary or the database would get crowded.
    #  Also should delete whenever a profile is deleted.


   # Generate the full URL to the newly uploaded image
   "https://s3-us-west-2.amazonaws.com/#{bucket_name}/#{bucket_name}/#{filename}"
 end

 # Generates a unique filename with a given extension
 defp unique_filename(extension) do
   UUID.uuid4(:hex) <> extension
 end

 # Helper functions to read the binary to determine the image extension
 defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
 defp image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"

end

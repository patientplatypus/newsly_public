defmodule Newsly.SignonController do
  import Ecto.Query
  alias Newsly.{Repo, User, RoomChannel}

  def login(username, password, socket) do
    #Repo.insert(%User{username: username, password: password})
    target_records =
      from(u in User, where: u.username == ^username)
      |> Repo.one()
    IO.inspect target_records
    #if target_records == nil do
    #  IO.puts "condition nil"
    #  else do
    #end

    cond do
      target_records==nil->
        IO.puts "condition nil (record DNE)"
        # {:error, %{reason: "condition nil (record DNE)"}}
        RoomChannel.signOnControllerReturn(%{msg: "condition nil (record DNE)"},socket)
      true ->
        IO.puts "condition not nil (record found!)"
        IO.puts "username in database"
        IO.inspect target_records.username
        IO.puts "password in database"
        IO.inspect target_records.password
        IO.puts "supplied password"
        IO.puts password
        cond do
          target_records.password==password->
            IO.puts "password matches with database!"
            # {:ok, %{reason: "password matches with database!"}}
            RoomChannel.signOnControllerReturn(%{msg: "password matches with database!", profileImageURL: target_records.profileImageURL},socket)
          true->
            IO.puts "password does not match database"
            # {:error, %{reason: "password does not match database"}}
            RoomChannel.signOnControllerReturn(%{msg: "password does not match database"},socket)
        end
    end

  end

  def signup(username, password, socket) do

    target_records =
      from(u in User, where: u.username == ^username)
      |> Repo.one()
    IO.inspect target_records

    cond do
      target_records==nil->
        IO.puts "condition nil (record DNE)"
        Repo.insert(%User{username: username, password: password, profileImageURL: nil, userupvotes: 0, userdownvotes: 0, userflaggedcount: 0})
        # {:ok, %{reason: "User added!"}}
        RoomChannel.signOnControllerReturn(%{msg: "User added!"},socket)
        # RoomChannel.signOnControllerReturn( "User added!", socket)
      true ->
        # {:error, %{reason: "username exists in database"}}
        RoomChannel.signOnControllerReturn(%{msg: "username exists in database"},socket)
    end
  end


end

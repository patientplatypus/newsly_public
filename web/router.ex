defmodule Newsly.Router do
  use Newsly.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Newsly do
    pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index
    resources "/comment", CommentsController
    get "/", HealthCheck, :index
  end

  scope "/api", Newsly do
    pipe_through :api
    resources "/articles", ArticleAPIController
    resources "/upload", UploadController, only: [:create]
    resources "/user", UserController, only: [:index]
  end

  # note that sudo mix phx.routes does NOT generate routes, only shows you which ones currently exist!!!
  #patientplatypus:~/Documents/newsly:15:36:35$sudo mix phx.routes
  #Password:
  #page_path  GET     /                    Newsly.PageController :index
  # api_path  GET     /api/entry           Newsly.ApiController :index
  # api_path  GET     /api/entry/:id/edit  Newsly.ApiController :edit
  # api_path  GET     /api/entry/new       Newsly.ApiController :new
  # api_path  GET     /api/entry/:id       Newsly.ApiController :show
  # api_path  POST    /api/entry           Newsly.ApiController :create
  # api_path  PATCH   /api/entry/:id       Newsly.ApiController :update
  #           PUT     /api/entry/:id       Newsly.ApiController :update
  # api_path  DELETE  /api/entry/:id       Newsly.ApiController :delete


  # Other scopes may use custom stacks.
  #scope "/api", Newsly do
  #  pipe_through :browser
  #  get "/entry", ApiController, :index
  #end

  #scope "/", RestApi do
  #  pipe_through :api
  #  resources "/posts", PostController
  #end

end

defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Blog.Guardian.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", BlogWeb do
    pipe_through [:api, :authenticated]

    get "/user", UserController, :index
    get "/user/:id", UserController, :show
    delete "/user/me", UserController, :delete

    post "/post", PostController, :create
    get "/post", PostController, :index
    get "/post/search", PostController, :search
    get "/post/:id", PostController, :show
    put "/post/:id", PostController, :update
    delete "/post/:id", PostController, :delete
  end

  scope "/api", BlogWeb do
    pipe_through :api

    post "/user", UserController, :create
    post "/login", SessionController, :create
  end
end

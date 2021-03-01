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

    post "/user", UserController, :create
    get "/user", UserController, :index
    get "/user/:id", UserController, :show
    delete "/user/:id", UserController, :delete
  end
end

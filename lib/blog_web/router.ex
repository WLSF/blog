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
    pipe_through :api

    resources "/users", UserController
  end
end

defmodule BlogWeb.UserView do
  use BlogWeb, :view

  alias BlogWeb.UserView
  alias BlogWeb.SessionView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("login.json", %{token: token}) do
    %{data: render_one(token, SessionView, "token.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      display_name: user.display_name,
      email: user.email,
      image: user.image
    }
  end
end

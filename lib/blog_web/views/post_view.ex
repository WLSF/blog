defmodule BlogWeb.PostView do
  use BlogWeb, :view

  alias BlogWeb.PostView
  alias BlogWeb.UserView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "full_post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "full_post.json")}
  end

  def render("create.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("full_post.json", %{post: post}) do
    %{
      id: post.id,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at,
      title: post.title,
      content: post.content,
      user: render_one(post.user, UserView, "user.json")
    }
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      user_id: post.user_id
    }
  end
end

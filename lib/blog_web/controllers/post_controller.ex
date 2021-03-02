defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Guardian
  alias Blog.Topics
  alias Blog.Topics.Post

  action_fallback BlogWeb.FallbackController

  def index(conn, _params) do
    posts = Topics.list_posts()
    render(conn, "index.json", posts: Topics.preload_user(posts))
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         {:ok, %Post{} = post} <- Topics.create_post(user, post_params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Post{} = post} <- Topics.get_post!(id) do
      render(conn, "show.json", post: Topics.preload_user(post))
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, %Post{} = post} <- Topics.get_post!(id),
         {:ok, %Post{} = post} <- Topics.update_post(post, post_params) do
      render(conn, "create.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         {:ok, %Post{} = post} <- Topics.get_post!(id),
         {:ok, %Post{}} <- Topics.delete_post(user, post) do
      send_resp(conn, :no_content, "")
    else
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{errors: %{message: "Unauthorized"}})

      e ->
        BlogWeb.FallbackController.call(conn, e)
    end
  end

  def search(conn, %{"q" => params}) do
    posts = Topics.search_by(params)
    render(conn, "index.json", posts: Topics.preload_user(posts))
  end
end

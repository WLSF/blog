defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Accounts
  alias Blog.Guardian
  alias Blog.Topics
  alias Blog.Topics.Post

  @create_attrs %{
    title: "Elixir Content",
    content: "Awesome content about elixir!"
  }

  @update_attrs %{
    title: "Updated title",
    content: "Updated content"
  }

  @invalid_attrs %{}

  def fixture(:post) do
    user = fixture(:user)
    {:ok, post} = Topics.create_post(user, @create_attrs)
    post
  end

  def fixture(:user) do
    attrs = %{
      display_name: "John Doe",
      email: "john#{:rand.uniform(40)}@doe.com",
      image: "s3_file_here.jpg",
      password: "anythingsecret"
    }

    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_post, :auth_user]

    test "lists all posts", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :index))

      assert [%{"title" => title, "content" => content, "user" => %{"id" => user_id}}] =
               json_response(conn, 200)["data"]

      assert post.title == title
      assert post.content == content
      assert post.user_id == user_id
    end
  end

  describe "index without auth" do
    setup [:create_post]

    test "renders error", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert response(conn, 401)
    end
  end

  describe "create post" do
    setup [:auth_user]

    test "renders post when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => _id,
               "title" => "" <> _title,
               "user" => %{"id" => user_id}
             } = json_response(conn, 200)["data"]

      assert user.id == user_id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert %{} = json_response(conn, 400)["errors"]
    end
  end

  describe "create post without auth" do
    setup [:create_post]

    test "renders error", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end
  end

  describe "update post" do
    setup [:create_post, :auth_user]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => _id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert %{} = json_response(conn, 400)["errors"]
    end
  end

  describe "update post without auth" do
    setup [:create_post]

    test "renders error", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert response(conn, 401)
    end
  end

  describe "delete post" do
    setup [:create_post, :auth_user]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 204)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert response(conn, 404)
    end

    test "renders error when invalid post_id", %{conn: conn} do
      post = fixture(:post)
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 401)
    end
  end

  describe "delete post without auth" do
    setup [:create_post]

    test "renders error", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 401)
    end
  end

  describe "search post" do
    setup [:create_post, :auth_user]

    test "renders posts by query", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :search), q: "elixir")
      assert [%{"title" => title}] = json_response(conn, 200)["data"]
      assert post.title == title
    end

    test "renders empty results", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :search), q: "oiasjdoifajsoidjfaosijdf")
      assert [] = json_response(conn, 200)["data"]
    end
  end

  describe "search post without auth" do
    setup [:create_post]

    test "renders error", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :search), q: "Elixir")
      assert response(conn, 401)
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end

  defp auth_user(%{conn: conn, post: post}) do
    {:ok, user} = Accounts.get_user!(post.user_id)
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    %{conn: conn}
  end

  defp auth_user(%{conn: conn}) do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    %{conn: conn, user: user}
  end
end

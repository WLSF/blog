defmodule Blog.TopicsTest do
  use Blog.DataCase

  alias Blog.Accounts
  alias Blog.Topics

  describe "posts" do
    alias Blog.Topics.Post

    @valid_attrs %{
      title: "Awesome Elixir",
      content: "Brand new post to evangelize and help younglings to grow on Elixir"
    }

    @update_attrs %{
      title: "Awesome updated Elixir",
      content: "We've updated all the post, but it's still awesome!"
    }

    @invalid_attrs %{}

    def post_fixture() do
      user = user_fixture()

      {:ok, post} = Topics.create_post(user, @valid_attrs)

      post
    end

    def user_fixture(attrs \\ %{}) do
      user_attrs = %{
        display_name: "John Doe",
        email: "john@doe.com",
        image: "s3_file_here.jpg",
        password: "anythingsecret"
      }

      {:ok, user} =
        attrs
        |> Enum.into(user_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert [%{title: title, content: content, user_id: user_id}] = Topics.list_posts()
      assert post.title == title
      assert post.content == content
      assert post.user_id == user_id
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert {:ok, post} == Topics.get_post!(post.id)
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()
      assert {:ok, %Post{} = _post} = Topics.create_post(user, @valid_attrs)
    end

    test "create_post/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.create_post(user, @invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = _post} = Topics.update_post(post, @update_attrs)
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_post(post, @invalid_attrs)
      assert {:ok, post} == Topics.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture() |> Topics.preload_user()
      assert {:ok, %Post{}} = Topics.delete_post(post.user, post)
      assert {:error, :not_found} = Topics.get_post!(post.id)
    end

    test "search_by/1 expression on the posts" do
      post = post_fixture()
      assert [%{title: title}] = Topics.search_by("elixir")
      assert post.title == title
    end
  end
end

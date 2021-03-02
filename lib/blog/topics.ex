defmodule Blog.Topics do
  @moduledoc """
  The Topics context.
  """

  alias Blog.Repo

  alias Blog.Topics.Post

  def preload_user(post), do: Repo.preload(post, :user)

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts, do: Repo.all(Post)

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    {:ok, Repo.get!(Post, id)}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(user, attrs \\ %{}) do
    attrs = mix_args(user, attrs)

    %Post{}
    |> Post.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    case Post.update_changeset(attrs) do
      %Ecto.Changeset{valid?: true} ->
        post
        |> Post.create_changeset(attrs)
        |> Repo.update()

      e ->
        {:error, e}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(user, %Post{} = post) do
    cond do
      user.id == post.user_id ->
        Repo.delete(post)

      true ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Searches by posts including the query params.

  ## Examples

      iex> search_by(query)
      {:ok, [%Post{}]}

  """
  def search_by(expression) do
    expression
    |> Post.query_by()
    |> Repo.all()
  end

  defp mix_args(user, %{"title" => _} = attrs) do
    Map.put(attrs, "user_id", user.id)
  end

  defp mix_args(user, %{title: _} = attrs) do
    Map.put(attrs, :user_id, user.id)
  end

  defp mix_args(_, %{} = attrs), do: attrs
end

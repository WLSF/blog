defmodule Blog.Topics.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "posts" do
    field :title, :string
    field :content, :string

    timestamps()

    belongs_to :user, Blog.Accounts.User
  end

  @publish_fields ~w(title content user_id)a
  @update_fields ~w(title content)a

  @doc false
  def create_changeset(post, attrs) do
    post
    |> cast(attrs, @publish_fields)
    |> validate_required(@publish_fields)
  end

  @doc false
  def update_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @update_fields)
    |> validate_required(@update_fields)
  end

  @spec query_by(String.t()) :: Ecto.Query.t()
  def query_by(exp) do
    from p in __MODULE__,
      where:
        ilike(p.title, ^"%#{exp}%") or
          ilike(p.content, ^"%#{exp}%")
  end
end

defmodule Blog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :display_name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string
    field :password, virtual: true

    timestamps()
  end

  @fields ~w(display_name email image password)a

  @doc false
  def signup_changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end

defmodule Blog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2
  alias Blog.Accounts.Validators, as: Validate

  @derive {Jason.Encoder, [:display_name, :email, :image]}

  schema "users" do
    field :display_name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @fields ~w(display_name email image password)a

  @doc false
  def signup_changeset(user, attrs) do
    user
    |> cast(attrs, @fields ++ [:password_hash])
    |> validate_required(@fields)
    |> Validate.display_name()
    |> Validate.email()
    |> Validate.password()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
  end
end

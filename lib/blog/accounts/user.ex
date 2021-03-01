defmodule Blog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2

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
    |> put_password_hash()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end

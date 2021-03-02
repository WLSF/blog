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

  @signup_fields ~w(display_name email image password)a
  @login_fields ~w(email password)a

  @doc false
  def signup_changeset(user, attrs) do
    user
    |> cast(attrs, @signup_fields ++ [:password_hash])
    |> validate_required(@signup_fields)
    |> Validate.display_name()
    |> Validate.email()
    |> Validate.password()
  end

  def login_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @login_fields)
    |> validate_required(@login_fields)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @signup_fields)
  end

  def check_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      user
    else
      false
    end
  end
end

defmodule Blog.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Blog.Repo
  alias Blog.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.signup_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticates the User with email and password.

  ## Examples

      iex> auth_user(%{email: _, password: _})
      {:ok, %User{}}
  """
  def auth_user(params) do
    params
    |> User.login_changeset()
    |> case do
      %Ecto.Changeset{valid?: true} ->
        do_auth_user(params)

      e ->
        {:error, e}
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp do_auth_user(%{"email" => email, "password" => password}) do
    User
    |> Repo.get_by!(email: email)
    |> User.check_password(password)
    |> case do
      false ->
        {:error, :invalid_credentials}

      user ->
        {:ok, user}
    end
  rescue
    Ecto.No.NoResultsError -> {:error, :invalid_credentials}
  end
end

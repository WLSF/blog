defmodule BlogWeb.UserController do
  use BlogWeb, :controller

  alias Blog.Accounts
  alias Blog.Accounts.User
  alias Blog.Guardian

  action_fallback BlogWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("login.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Accounts.get_user!(id) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _params) do
    with {:ok, %User{} = user} <- Guardian.Plug.current_resource(conn),
         {:ok, %User{} = user} <- Accounts.get_user!(user.id),
         {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

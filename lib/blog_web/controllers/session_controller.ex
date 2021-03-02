defmodule BlogWeb.SessionController do
  use BlogWeb, :controller

  alias Blog.Accounts
  alias Blog.Accounts.User
  alias Blog.Guardian

  action_fallback BlogWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Accounts.auth_user(params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    else
      {:error, :invalid_credentials} ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: %{message: "invalid credentials"}})

      error ->
        BlogWeb.FallbackController.call(conn, error)
    end
  end
end

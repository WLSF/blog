defmodule BlogWeb.UserControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Accounts

  @create_attrs %{
    display_name: "John Doe",
    email: "john@doe.com",
    image: "s3_image.jpg",
    password: "anythingsecret"
  }

  @invalid_attrs %{}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"token" => _} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders already exists error when duplicated user", %{conn: conn} do
      post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{"email" => ["has already been taken"]} = json_response(conn, 409)["errors"]
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end

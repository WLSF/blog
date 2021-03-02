defmodule BlogWeb.SessionControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Accounts

  @create_attrs %{
    display_name: "John Doe",
    image: "s3_link_here.jpg"
  }

  @login_attrs %{
    email: "john@doe.com",
    password: "anythingsecret"
  }

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, _} =
      @create_attrs
      |> Map.merge(@login_attrs)
      |> Accounts.create_user()

    {:ok, conn: conn}
  end

  describe "login" do
    test "renders session token when user is valid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), @login_attrs)
      assert %{"token" => _} = json_response(conn, 200)["data"]
    end
  end
end

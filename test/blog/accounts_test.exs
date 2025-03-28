defmodule Blog.AccountsTest do
  use Blog.DataCase

  alias Blog.Accounts

  describe "users" do
    alias Blog.Accounts.User

    @valid_attrs %{
      display_name: "John Doe",
      email: "john@doe.com",
      image: "link_to_s3_image.jpg",
      password: "anythingsecure"
    }

    @invalid_attrs %{
      display_name: "123",
      email: "wrong_email",
      image: "",
      password: "small"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert [%{display_name: name, email: email, image: image}] = Accounts.list_users()
      assert user.display_name == name
      assert user.email == email
      assert user.image == image
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()

      assert {:ok, %User{display_name: name, email: email, image: image}} =
               Accounts.get_user!(user.id)

      assert user.display_name == name
      assert user.email == email
      assert user.image == image
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = _user} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user!(user.id)
    end
  end
end

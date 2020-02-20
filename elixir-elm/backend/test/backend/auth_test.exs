defmodule Backend.AuthTest do
  use Backend.DataCase

  describe "users" do
    alias Backend.Auth.User

    @valid_attrs %{email: "foo@foo.com", is_active: true, password: "Admin123!"}
    @invalid_attrs %{email: "foo", is_active: true, password: "Ad"}

    test "returns 'Invalid email'when the email is incorrect" do
      user = %User{} |> User.changeset(@invalid_attrs)
      assert {"Invalid email", []} == user.errors[:email]
    end

    test "return 'Password should be at least 8 characters long' when the password is incorrect" do
      user = %User{} |> User.changeset(%{@invalid_attrs | email: "bar@baz.com"})
      assert {"Password should be at least 8 characters long", []} == user.errors[:password]
    end

    test "is valid when the email and password is correct" do
      user = %User{} |> User.changeset(@valid_attrs)
      assert user.valid?
    end

  end
end

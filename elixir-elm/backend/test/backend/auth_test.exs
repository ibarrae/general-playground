defmodule Backend.AuthTest do
  use Backend.DataCase

  alias Backend.Auth

  describe "users" do
    alias Backend.Auth.User

    @valid_attrs %{email: "foo@foo.com", is_active: true, password: "some password"}
    @invalid_attrs %{email: "foo", is_active: true, password: "foo"}

    test "returns 'Invalid email' as an :email error for email is incorrect" do
      user = %User{} |> User.changeset(@invalid_attrs)
      assert {"Invalid email", []} == user.errors[:email]
    end

    test "is valid when the email is correct" do
      user = %User{} |> User.changeset(@valid_attrs)
      assert user.valid?
    end

  end
end

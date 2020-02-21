defmodule BackendWeb.UserControllerTest do
  use Backend.DataCase

  alias BackendWeb.UserController
  alias Backend.Auth
  alias Backend.Auth.User

  describe "valid_credentials" do
    test "returns false when the user is not found ~ nil" do
      assert false == UserController.valid_credentials(nil, "ha!")
    end

    test "returns false when the user is inactive" do
      assert false == UserController.valid_credentials(%User{is_active: false}, "foo")
    end

    test "returns true when the passwords match and the user is active" do
      %User{}
        |> User.changeset(%{password: "Admin123", is_active: true, email: "foo@foo.com"})
        |> Repo.insert()
      assert true ==
        Auth.get_by_email("foo@foo.com") |> UserController.valid_credentials("Admin123")
    end
  end
end

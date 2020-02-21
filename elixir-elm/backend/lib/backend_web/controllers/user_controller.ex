defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Auth
  alias Backend.Auth.User
  alias BackendWeb.UserView
  alias BackendWeb.ErrorView
  alias Backend.JWTSerializer

  action_fallback BackendWeb.FallbackController

  def authenticate(conn, email, received_pwd) do
    user = Auth.get_by_email(email)
    case valid_credentials(user, received_pwd) do
      true ->
        conn |> assign(:active_user, user)

      false ->
        halt(conn)
    end
  end

  def valid_credentials(%User{} = user, received_pwd) do
    with true <- user.is_active,
      {:ok, _} <- Bcrypt.check_pass(user, received_pwd)
        do true
    else
      _ -> false
    end
  end

  def valid_credentials(_user, _pwd), do: false

  def sign_in(conn, _) do
    user = conn.assigns.active_user
    with %User{} <- user,
      {:ok, jwt, _claims} = JWTSerializer.encode_and_sign(user) do
        conn
          |> put_status(:ok)
          |> put_view(UserView)
          |> render("sign_in.json", jwt: jwt)

    else
      _ ->
        conn
          |> put_status(:unauthorized)
          |> put_view(ErrorView)
          |> render("error.json", message: "Unauthorized")
    end
  end
end

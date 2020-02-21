defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Auth
  alias Backend.Auth.User

  action_fallback BackendWeb.FallbackController

  def authenticate(conn, email, received_pwd) do
    user = Auth.get_by_email(email)
    case valid_credentials(user, received_pwd) do
      true ->
        conn
        |> assign(:active_user, user)
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
    %{status: :ok}
  end
end

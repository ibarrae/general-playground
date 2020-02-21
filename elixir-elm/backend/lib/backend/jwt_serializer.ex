defmodule Backend.JWTSerializer do
  use Guardian, otp_app: :backend

  alias Backend.Repo
  alias Backend.Auth.User

  def subject_for_token(user = %User{}, _claims), do: {:ok, "User:#{user.id}"}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims("User:" <> id), do: {:ok, Repo.get(User, id)}
  def resource_from_claims(_), do: {:error, "Unknown resource type"}
end

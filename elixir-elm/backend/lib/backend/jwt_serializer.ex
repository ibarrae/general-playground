defmodule Backend.JWTSerializer do
  use Guardian, otp_app: :backend

  alias Backend.Repo
  alias Backend.Auth.User

  @unknown_resource {:error, "Unknown resource type"}

  def subject_for_token(user = %User{}, _claims), do: {:ok, "User:#{user.id}"}
  def subject_for_token(_, _), do: @unknown_resource

  def resource_from_claims("User:" <> id), do: {:ok, Repo.get(User, id)}
  def resource_from_claims(_), do: @unknown_resource
end

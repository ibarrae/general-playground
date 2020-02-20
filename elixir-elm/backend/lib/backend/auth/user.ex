defmodule Backend.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: true
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :is_active, :password])
    |> unique_constraint(:email)
    |> validate_email()
    |> validate_password()
    |> put_hash_password()
  end


  defp validate_email(
    %Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset
  ) do
    valid_email = email |>
      String.match?(~r/^((?!\.)[\w-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$/)
    if valid_email do
      changeset
    else
      add_error(changeset, :email, "Invalid email")
    end
  end

  defp validate_email(c) do c end

  defp validate_password(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    if String.length(password) < 8 do
      add_error(changeset, :password, "Password should be at least 8 characters long")
    else
      changeset
    end
  end

  defp validate_password(c) do c end

  defp put_hash_password(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_hash_password(c) do c end
end

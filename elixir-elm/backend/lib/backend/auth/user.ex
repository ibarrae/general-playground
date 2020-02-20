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
    |> put_hash_password()
  end


  defp validate_email(
    %Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset
  ) do
    valid_email = String.match?(
      email,
      ~r/^((?!\.)[\w-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$/
    )
    if valid_email do
      changeset
    else
      add_error(changeset, :email, "Invalid email")
    end
  end

  defp validate_email(changeset) do changeset end

  defp put_hash_password(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_hash_password(changeset) do changeset end
end

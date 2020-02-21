defmodule Backend.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :founded, :date
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :founded])
    |> validate_required([:name, :founded])
  end
end

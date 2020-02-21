defmodule Backend.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string, null: false
      add :founded, :date, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:cities, [:name])
  end
end

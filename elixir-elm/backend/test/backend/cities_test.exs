defmodule Backend.CitiesTest do
  use Backend.DataCase

  alias Backend.Cities

  describe "cities" do
    alias Backend.Cities.City

    @valid_attrs %{founded: ~D[2010-04-17], name: "some name"}
    @update_attrs %{founded: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{founded: nil, name: nil}

    def city_fixture(attrs \\ %{}) do
      {:ok, city} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cities.create_city()

      city
    end

    test "list_cities/0 returns all cities" do
      city = city_fixture()
      assert Cities.list_cities() == [city]
    end

    test "get_city!/1 returns the city with given id" do
      city = city_fixture()
      assert Cities.get_city!(city.id) == city
    end

    test "create_city/1 with valid data creates a city" do
      assert {:ok, %City{} = city} = Cities.create_city(@valid_attrs)
      assert city.founded == ~D[2010-04-17]
      assert city.name == "some name"
    end

    test "create_city/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cities.create_city(@invalid_attrs)
    end

    test "update_city/2 with valid data updates the city" do
      city = city_fixture()
      assert {:ok, %City{} = city} = Cities.update_city(city, @update_attrs)
      assert city.founded == ~D[2011-05-18]
      assert city.name == "some updated name"
    end

    test "update_city/2 with invalid data returns error changeset" do
      city = city_fixture()
      assert {:error, %Ecto.Changeset{}} = Cities.update_city(city, @invalid_attrs)
      assert city == Cities.get_city!(city.id)
    end

    test "delete_city/1 deletes the city" do
      city = city_fixture()
      assert {:ok, %City{}} = Cities.delete_city(city)
      assert_raise Ecto.NoResultsError, fn -> Cities.get_city!(city.id) end
    end

    test "change_city/1 returns a city changeset" do
      city = city_fixture()
      assert %Ecto.Changeset{} = Cities.change_city(city)
    end
  end
end

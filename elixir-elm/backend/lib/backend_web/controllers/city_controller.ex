defmodule BackendWeb.CityController do
  use BackendWeb, :controller

  alias Backend.Cities
  alias Backend.Cities.City

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    cities = Cities.list_cities()
    render(conn, "index.json", cities: cities)
  end

  def create(conn, %{"city" => city_params}) do
    with {:ok, %City{} = city} <- Cities.create_city(city_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.city_path(conn, :show, city))
      |> render("show.json", city: city)
    end
  end

  def show(conn, %{"id" => id}) do
    city = Cities.get_city!(id)
    render(conn, "show.json", city: city)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Cities.get_city!(id)

    with {:ok, %City{} = city} <- Cities.update_city(city, city_params) do
      render(conn, "show.json", city: city)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Cities.get_city!(id)

    with {:ok, %City{}} <- Cities.delete_city(city) do
      send_resp(conn, :no_content, "")
    end
  end
end

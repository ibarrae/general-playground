defmodule BackendWeb.CityView do
  use BackendWeb, :view
  alias BackendWeb.CityView

  def render("index.json", %{cities: cities}) do
    %{data: render_many(cities, CityView, "city.json")}
  end

  def render("show.json", %{city: city}) do
    %{data: render_one(city, CityView, "city.json")}
  end

  def render("city.json", %{city: city}) do
    %{id: city.id,
      name: city.name,
      founded: city.founded}
  end
end

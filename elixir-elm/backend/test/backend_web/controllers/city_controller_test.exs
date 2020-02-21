defmodule BackendWeb.CityControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Cities
  alias Backend.Cities.City
  import Backend.JWTSerializer
  alias Backend.Auth

  @create_attrs %{
    founded: ~D[2010-04-17],
    name: "some name"
  }
  @update_attrs %{
    founded: ~D[2011-05-18],
    name: "some updated name"
  }
  @invalid_attrs %{founded: nil, name: nil}
  @expected_errors ["name can't be blank", "founded can't be blank"]

  def fixture(:city) do
    {:ok, city} = Cities.create_city(@create_attrs)
    city
  end

  setup %{conn: conn} do
    {:ok, user} =
      Auth.create_user(
        %{is_active: true, email: "foo@foo.com", password: "Admin123"}
      )
    {:ok, jwt, _} = encode_and_sign(user)
    req = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> jwt)
    {:ok, conn: req}
  end

  describe "index" do
    test "lists all cities", %{conn: conn} do
      conn = get(conn, Routes.city_path(conn, :index))
      assert json_response(conn, 200)["cities"] == []
    end
  end

  describe "create city" do
    test "renders city when data is valid", %{conn: conn} do
      conn = post(conn, Routes.city_path(conn, :create), city: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["city"]

      conn = get(conn, Routes.city_path(conn, :show, id))

      assert %{
               "id" => id,
               "founded" => "2010-04-17",
               "name" => "some name"
             } = json_response(conn, 200)["city"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.city_path(conn, :create), city: @invalid_attrs)
      assert @expected_errors == json_response(conn, 422)["error"]
    end
  end

  describe "update city" do
    setup [:create_city]

    test "renders city when data is valid", %{conn: conn, city: %City{id: id} = city} do
      conn = put(conn, Routes.city_path(conn, :update, city), city: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["city"]

      conn = get(conn, Routes.city_path(conn, :show, id))

      assert %{
               "id" => id,
               "founded" => "2011-05-18",
               "name" => "some updated name"
             } = json_response(conn, 200)["city"]
    end

    test "renders errors when data is invalid", %{conn: conn, city: city} do
      conn = put(conn, Routes.city_path(conn, :update, city), city: @invalid_attrs)
      assert @expected_errors == json_response(conn, 422)["error"]
    end
  end

  describe "delete city" do
    setup [:create_city]

    test "deletes chosen city", %{conn: conn, city: city} do
      conn = delete(conn, Routes.city_path(conn, :delete, city))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.city_path(conn, :show, city))
      end
    end
  end

  defp create_city(_) do
    city = fixture(:city)
    {:ok, city: city}
  end
end

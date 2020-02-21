defmodule BackendWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BackendWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BackendWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{valid?: false, errors: errors}}) do
    readable_errors =
      for { k, v } <- errors, into: [] do
        { msg, _ } = v
        Atom.to_string(k) <> " " <> msg
      end

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BackendWeb.ErrorView)
    |> render("error.json", message: readable_errors)
  end
end

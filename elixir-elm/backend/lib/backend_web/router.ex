defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth do
    plug BasicAuth,
      callback: &BackendWeb.UserController.authenticate/3
  end

  scope "/", BackendWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", BackendWeb do
    pipe_through [:api, :basic_auth]
    post "/users/sign-in", UserController, :sign_in
  end

  scope "/api", BackendWeb do
    pipe_through :api
  end
end

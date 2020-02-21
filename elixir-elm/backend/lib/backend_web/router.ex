defmodule BackendWeb.Router do
  use BackendWeb, :router
  alias BackendWeb.UserController

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
      callback: &UserController.authenticate/3
  end

  scope "/", BackendWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BackendWeb do
    pipe_through :api

    pipe_through :basic_auth
    post "/users/sign-in", UserController, [:sign_in]
  end
end

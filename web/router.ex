defmodule TodoApi.Router do
  use TodoApi.Web, :router

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

  scope "/", TodoApi do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/authentication", AuthenticationController, :create
    resources "/todos", TodoController, only: [:index, :create, :show, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoApi do
  #   pipe_through :api
  # end
end

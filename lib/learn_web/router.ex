defmodule LearnWeb.Router do
  use LearnWeb, :router

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

  scope "/", LearnWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/polls", PollController, :index
    post "/polls", PollController, :create
    get "/polls/new", PollController, :new

    resources "/users", UserController, only: [:new, :show, :create]
    resources "/sessions", SessionController, only: [:create]
    get "/options/:id/vote", PollController, :vote
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", LearnWeb do
  #   pipe_through :api
  # end
end

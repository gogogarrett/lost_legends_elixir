defmodule LostLegends.Router do
  use LostLegends.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LostLegends.Auth, repo: LostLegends.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LostLegends do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, except: [:index]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/lobby", LostLegends do
    pipe_through [:browser, :authenticate_user]

    resources "/", LobbyController, only: [:index]
    resources "/battles", BattleController, only: [:show]
  end
end

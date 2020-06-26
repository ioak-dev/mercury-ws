defmodule MercuryWeb.Router do
  use MercuryWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Mercury.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :graphql do
    plug MercuryWeb.Context
  end

  scope "/api", MercuryWeb do
    pipe_through :api

    # get "/account/user/:space/session/:session_id", UserController, :session
    # get "/account/user/:space", UserController, :index
  end

  scope "/api", MercuryWeb do
    pipe_through [:api]
    # pipe_through [:api, :auth, :ensure_auth]
    # get "/blog/post", PostController, :index

    get "/account/user/:space/session/:session_id", UserController, :session
    get "/account/user/:space", UserController, :index
    get "/database/:space", DatabaseController, :index
  end

  scope "/api", MercuryWeb do
    pipe_through [:api, :auth, :ensure_auth]

    get "/text/generate/:language/:type", TextController, :generate
  end

  # Graph QL router setup
  scope "/" do
    pipe_through [:api, :graphql]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MercuryWeb.Schema,
      interface: :simple,
      context: %{pubsub: MercuryWeb.Endpoint}
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MercuryWeb.Telemetry
    end
  end
end

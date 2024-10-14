defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug CORSPlug
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]

    get "/roles", RoleController, :index   # Liste tous les rôles
    get "/roles/:id", RoleController, :show # Récupère un rôle par son ID

    get "/teams", TeamController, :index   # Liste toutes les équipes
    get "/teams/:id", TeamController, :show   # Récupère une équipe et ses utilisateurs
    put "/teams/:id", TeamController, :update # Met à jour une équipe
    post "/teams", TeamController, :create # Met à jour une équipe
    delete "/teams/:id", TeamController, :delete # Met à jour une équipe

    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create
    get "/clocks/:user_id/:id", ClockController, :show

    get "/workingtime/:user_id", WorkingTimeController, :index
    post "/workingtime/:user_id", WorkingTimeController, :create
    get "/workingtime/:user_id/:id", WorkingTimeController, :show
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

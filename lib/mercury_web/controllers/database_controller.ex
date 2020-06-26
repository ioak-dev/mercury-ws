defmodule MercuryWeb.DatabaseController do
    use MercuryWeb, :controller
    use HTTPoison.Base
  
    alias Mercury.Database
  
    action_fallback MercuryWeb.FallbackController
  
    def index(conn, %{"space" => space}) do
      Database.create_schema("mercury_#{space}")
      send_resp(conn, :no_content, "")
    end
  
end  
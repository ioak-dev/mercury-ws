defmodule MercuryWeb.UserController do
  use MercuryWeb, :controller
  use HTTPoison.Base

  alias Mercury.Accounts
  alias Mercury.Accounts.User
  alias Mercury.Database

  action_fallback MercuryWeb.FallbackController

  def index(conn, %{"space" => space}) do
    Database.create_schema("mercury_#{space}")
    users = Accounts.list_users(space)
    render(conn, "index.json", users: users)
  end

  def session(conn, %{"space" => space, "session_id" => session_id}) do
    case HTTPoison.get!("#{Application.get_env(:mercury, :oneauth_api_url)}/auth/#{space}/session/#{session_id}") do
      %HTTPoison.Response{status_code: 200, body: body} -> 
        user_from_source = body |> Poison.decode!
        user_params = %{
          email: user_from_source["email"],
          first_name: user_from_source["firstName"],
          last_name: user_from_source["lastName"],
          user_id: user_from_source["userId"],
          type: user_from_source["type"]
        }

        case Accounts.get_user_by_user_id!(space, user_from_source["userId"]) do 
          %Accounts.User{} = user ->
            {:ok, updated_user} = Accounts.update_user(space, user, user_params)
            # render(conn, "session.json", %{user: updated_user, token: user_from_source["token"]})
            {:ok, token, _} = updated_user |> Poison.encode! |> Mercury.Guardian.encode_and_sign
            render(conn, "session.json", %{user: updated_user, token: token})
          _ ->
            {:ok, created_user} = Accounts.create_user(space, user_params)
            # render(conn, "session.json", %{user: created_user, token: user_from_source["token"]})
            {:ok, token, _} = created_user |> Poison.encode! |> Mercury.Guardian.encode_and_sign
            render(conn, "session.json", %{user: created_user, token: token})
        end
      %HTTPoison.Response{status_code: 404, body: body} ->
        send_resp(conn, :not_found, body)
      %HTTPoison.Error{} -> send_resp(conn, :internal_server_error, "unknown error")
      _ -> send_resp(conn, :internal_server_error, "unknown error")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

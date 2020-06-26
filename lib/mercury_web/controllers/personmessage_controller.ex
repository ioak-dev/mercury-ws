defmodule MercuryWeb.PersonmessageController do
  use MercuryWeb, :controller

  alias Mercury.Messagestream
  alias Mercury.Messagestream.Personmessage

  action_fallback MercuryWeb.FallbackController

  def index(conn, _params) do
    personmessages = Messagestream.list_personmessages()
    render(conn, "index.json", personmessages: personmessages)
  end

  def create(conn, %{"personmessage" => personmessage_params}) do
    with {:ok, %Personmessage{} = personmessage} <- Messagestream.create_personmessage(personmessage_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.personmessage_path(conn, :show, personmessage))
      |> render("show.json", personmessage: personmessage)
    end
  end

  def show(conn, %{"id" => id}) do
    personmessage = Messagestream.get_personmessage!(id)
    render(conn, "show.json", personmessage: personmessage)
  end

  def update(conn, %{"id" => id, "personmessage" => personmessage_params}) do
    personmessage = Messagestream.get_personmessage!(id)

    with {:ok, %Personmessage{} = personmessage} <- Messagestream.update_personmessage(personmessage, personmessage_params) do
      render(conn, "show.json", personmessage: personmessage)
    end
  end

  def delete(conn, %{"id" => id}) do
    personmessage = Messagestream.get_personmessage!(id)

    with {:ok, %Personmessage{}} <- Messagestream.delete_personmessage(personmessage) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule MercuryWeb.PersonmessageControllerTest do
  use MercuryWeb.ConnCase

  alias Mercury.Messagestream
  alias Mercury.Messagestream.Personmessage

  @create_attrs %{
    content: "some content",
    receiver: "some receiver",
    sender: "some sender"
  }
  @update_attrs %{
    content: "some updated content",
    receiver: "some updated receiver",
    sender: "some updated sender"
  }
  @invalid_attrs %{content: nil, receiver: nil, sender: nil}

  def fixture(:personmessage) do
    {:ok, personmessage} = Messagestream.create_personmessage(@create_attrs)
    personmessage
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all personmessages", %{conn: conn} do
      conn = get(conn, Routes.personmessage_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create personmessage" do
    test "renders personmessage when data is valid", %{conn: conn} do
      conn = post(conn, Routes.personmessage_path(conn, :create), personmessage: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.personmessage_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some content",
               "receiver" => "some receiver",
               "sender" => "some sender"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.personmessage_path(conn, :create), personmessage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update personmessage" do
    setup [:create_personmessage]

    test "renders personmessage when data is valid", %{conn: conn, personmessage: %Personmessage{id: id} = personmessage} do
      conn = put(conn, Routes.personmessage_path(conn, :update, personmessage), personmessage: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.personmessage_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some updated content",
               "receiver" => "some updated receiver",
               "sender" => "some updated sender"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, personmessage: personmessage} do
      conn = put(conn, Routes.personmessage_path(conn, :update, personmessage), personmessage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete personmessage" do
    setup [:create_personmessage]

    test "deletes chosen personmessage", %{conn: conn, personmessage: personmessage} do
      conn = delete(conn, Routes.personmessage_path(conn, :delete, personmessage))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.personmessage_path(conn, :show, personmessage))
      end
    end
  end

  defp create_personmessage(_) do
    personmessage = fixture(:personmessage)
    %{personmessage: personmessage}
  end
end

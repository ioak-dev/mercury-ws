defmodule Mercury.MessagestreamTest do
  use Mercury.DataCase

  alias Mercury.Messagestream

  describe "personmessages" do
    alias Mercury.Messagestream.Personmessage

    @valid_attrs %{content: "some content", receiver: "some receiver", sender: "some sender"}
    @update_attrs %{content: "some updated content", receiver: "some updated receiver", sender: "some updated sender"}
    @invalid_attrs %{content: nil, receiver: nil, sender: nil}

    def personmessage_fixture(attrs \\ %{}) do
      {:ok, personmessage} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messagestream.create_personmessage()

      personmessage
    end

    test "list_personmessages/0 returns all personmessages" do
      personmessage = personmessage_fixture()
      assert Messagestream.list_personmessages() == [personmessage]
    end

    test "get_personmessage!/1 returns the personmessage with given id" do
      personmessage = personmessage_fixture()
      assert Messagestream.get_personmessage!(personmessage.id) == personmessage
    end

    test "create_personmessage/1 with valid data creates a personmessage" do
      assert {:ok, %Personmessage{} = personmessage} = Messagestream.create_personmessage(@valid_attrs)
      assert personmessage.content == "some content"
      assert personmessage.receiver == "some receiver"
      assert personmessage.sender == "some sender"
    end

    test "create_personmessage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messagestream.create_personmessage(@invalid_attrs)
    end

    test "update_personmessage/2 with valid data updates the personmessage" do
      personmessage = personmessage_fixture()
      assert {:ok, %Personmessage{} = personmessage} = Messagestream.update_personmessage(personmessage, @update_attrs)
      assert personmessage.content == "some updated content"
      assert personmessage.receiver == "some updated receiver"
      assert personmessage.sender == "some updated sender"
    end

    test "update_personmessage/2 with invalid data returns error changeset" do
      personmessage = personmessage_fixture()
      assert {:error, %Ecto.Changeset{}} = Messagestream.update_personmessage(personmessage, @invalid_attrs)
      assert personmessage == Messagestream.get_personmessage!(personmessage.id)
    end

    test "delete_personmessage/1 deletes the personmessage" do
      personmessage = personmessage_fixture()
      assert {:ok, %Personmessage{}} = Messagestream.delete_personmessage(personmessage)
      assert_raise Ecto.NoResultsError, fn -> Messagestream.get_personmessage!(personmessage.id) end
    end

    test "change_personmessage/1 returns a personmessage changeset" do
      personmessage = personmessage_fixture()
      assert %Ecto.Changeset{} = Messagestream.change_personmessage(personmessage)
    end
  end
end

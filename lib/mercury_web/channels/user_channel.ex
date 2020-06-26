defmodule MercuryWeb.UserChannel do
  use MercuryWeb, :channel
  alias Mercury.Messagestream

  # intercept ["new_message"]

  def join("user:" <> id, _payload, socket) do
    if socket.assigns[:user]["id"] == String.to_integer(id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_message", payload, socket) do
    space = socket.assigns[:space]
    user = socket.assigns[:user]
    {:ok, created_record} = Messagestream.create_personmessage(space, %{
          "sender" => user["id"], 
          "receiver" => String.to_integer(payload["receiver"]), 
          "content" => payload["content"]
        })
    message = %{
      "sender" => created_record.sender,
      "receiver" => created_record.receiver,
      "content" => created_record.content,
      "inserted_at" => created_record.inserted_at
    }
    MercuryWeb.Endpoint.broadcast_from!(self(), "user:" <> payload["receiver"], "new_message", message)
    # if String.to_integer(payload["receiver"]) != user["id"] do
      broadcast socket, "new_message", message
    # end
    {:noreply, socket}
  end

  def handle_out("new_message", payload, socket) do
    IO.puts("[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]")
    payload
    # socket.assigns[:user]["id"] |> IO.inspect
    # broadcast socket, "new_message", payload
    # {:reply, {:ok, %{response: payload}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

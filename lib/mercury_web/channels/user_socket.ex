defmodule MercuryWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", MercuryWeb.RoomChannel
  channel "user:*", MercuryWeb.UserChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(%{"auth_token" => auth_token, "space" => space}, socket, _connect_info) do
    case Mercury.Guardian.decode_and_verify(auth_token, %{}, secret: "jwtsecret") do
      { :ok, claims } -> {:ok, assign(socket, user: claims["sub"] |> Poison.decode!, space: space)}
      { :error, reason } -> {:error, reason}
      nil -> {:error, "Unauthorized"}
    end
    # {:ok, assign(socket, :user_id, %{token: auth_token, name: "sdsdf"})}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MercuryWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end

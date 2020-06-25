defmodule AppnamehereWeb.Context do
    @behaviour Plug

    import Plug.Conn
    alias Appnamehere.Guardian

    def init(opts) do
        opts    
    end

    def call(conn, _) do
       context = build_context(conn) |> IO.inspect
       Absinthe.Plug.put_options(conn, context: context)
    end

    def build_context(conn) do
        [space | jwt_token] = conn
            |> get_req_header("authorization")
            |> deconstruct_auth_text
            |> IO.inspect
        case jwt_token |> authorize do
            {:ok, claims} -> %{user: claims, space: space}
            {:error, _} -> %{user: nil, space: space}
        end

        # with [token] <- get_req_header(conn, "authorization"),
        # {:ok, claims} <- authorize(token) do
        #     %{user: claims}
        # else
        #     nil -> {:error, "Unauthorized"}
        # end
    end

    defp deconstruct_auth_text([auth_text]), do: auth_text |> String.split(" ")

    defp deconstruct_auth_text(_), do: [nil, nil]

    defp authorize([token]) do
        case Guardian.decode_and_verify(token, %{}, secret: "jwtsecret") do
            { :ok, claims } -> {:ok, claims}
            { :error, reason } -> {:error, reason}
            nil -> {:error, "Unauthorized"}
        end
    end

    defp authorize(_token) do
        {:error, "no token"}
    end
    
end
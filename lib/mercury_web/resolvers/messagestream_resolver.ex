defmodule MercuryWeb.MessagestreamResolver do
    alias Mercury.Messagestream

    def personmessages(_root, %{self_id: self_id, other_id: other_id, last_index: last_index ,page_size: page_size}, %{context: %{space: space}}) do
        case space do
            nil -> {:error, "Space is missing"}
            _-> 
                results = Messagestream.list_personmessages(space, self_id, other_id, last_index, page_size) |> IO.inspect
                last_index =  (if length(results) > 0, do: List.last(results).id, else: nil)
                has_more = (if length(results) < page_size, do: false, else: true)
                {:ok, %{last_index: last_index, has_more: has_more, results: results}}
        end
    end

    def user(_root, args, %{context: %{space: space}}) do
        try do
            case space do
                nil -> {:error, "Space is missing"}
                _-> 
                    user = Accounts.get_user!(space, args.id)
                    {:ok, user}
            end
        rescue
            Ecto.NoResultsError -> {:ok, nil}
        end
    end

    def user_by_user_id(_root, args, %{context: %{space: space}}) do
        case space do
            nil -> {:error, "Space is missing"}
            _-> 
                user = Accounts.get_user_by_user_id!(space, args.user_id)
                {:ok, user}
        end
    end

    def create_user(_root, args, %{context: %{user: user, space: space}}) do
        case space do
            nil -> {:error, "Space is missing"}
            _-> 
                case Accounts.create_user(space, args.payload) do
                    {:ok, user} -> {:ok, user}
                    _error -> {:error, "error creating user"}
                end
        end
    end
end
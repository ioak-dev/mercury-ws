defmodule MercuryWeb.AccountsResolver do
    alias Mercury.Accounts

    def all_users(_root, _args, %{context: %{space: space}}) do
        case space do
            nil -> {:error, "Space is missing"}
            _-> {:ok, Accounts.list_users(space)}
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
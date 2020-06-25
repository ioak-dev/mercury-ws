defmodule AppnamehereWeb.Schema.Types.UserType do
    use Absinthe.Schema.Notation
    alias Appnamehere.Repo

    object :user do
        field :id, non_null(:id)
        field :user_id, :string
        field :first_name, :string
        field :last_name, :string
        field :email, :string
        field :type, :string
        field :posts, list_of(:post) do
            resolve(fn parent, _args, %{context: %{user: user, space: space}} ->
                case space do
                    nil -> {:error, "Space empty"}
                    _ -> {:ok, Ecto.assoc(parent, :posts) |> Repo.all(prefix:  "appnamehere_#{space}")}
                end
            end)
        end
    end

    input_object :user_input_type do
        field :user_id, non_null(:string)
        field :first_name, non_null(:string)
        field :last_name, non_null(:string)
        field :email, non_null(:string)
        field :type, non_null(:string)
    end
end
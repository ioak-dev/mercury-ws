defmodule AppnamehereWeb.Schema.Types.CommentType do
    use Absinthe.Schema.Notation
    alias Appnamehere.Repo

    object :comment do
        field :id, non_null(:id)
        field :description, :string
        field :user_id, :string
        field :user, :user do
            resolve(fn parent, _args, %{context: %{user: user, space: space}} ->
                case space do
                    nil -> {:error, "Space empty"}
                    _ -> {:ok, Ecto.assoc(parent, :user) |> Repo.one(prefix:  "appnamehere_#{space}")}
                end
            end)
        end
        field :post, :post do
            resolve(fn parent, _args, %{context: %{user: user, space: space}} ->
                case space do
                    nil -> {:error, "Space empty"}
                    _ -> {:ok, Ecto.assoc(parent, :post) |> Repo.one(prefix:  "appnamehere_#{space}")}
                end
            end)
        end
    end

    input_object :comment_input_type do
        field :description, non_null(:string)
        field :post_id, non_null(:string)
    end
end
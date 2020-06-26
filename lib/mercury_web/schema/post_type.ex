defmodule MercuryWeb.Schema.Types.PostType do
    use Absinthe.Schema.Notation
    alias Mercury.Repo

    object :post do
        field :id, non_null(:id)
        field :title, :string
        field :description, :string
        field :user_id, :string
        field :user, :user do
            resolve(fn parent, _args, %{context: %{user: user, space: space}} ->
                case space do
                    nil -> {:error, "Space empty"}
                    _ -> {:ok, Ecto.assoc(parent, :user) |> Repo.one(prefix:  "mercury_#{space}")}
                end
            end)
        end
    end

    input_object :post_input_type do
        field :title, non_null(:string)
        field :description, non_null(:string)
    end
end
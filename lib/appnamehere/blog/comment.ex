defmodule Appnamehere.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :description, :string
    belongs_to(:user, Appnamehere.Accounts.User)
    belongs_to(:post, Appnamehere.Blog.Post)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:description, :user_id, :post_id])
    |> validate_required([:description, :user_id, :post_id])
  end
end

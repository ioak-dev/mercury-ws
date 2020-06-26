defmodule Mercury.Messagestream.Personmessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "personmessages" do
    field :content, :string
    field :receiver, :integer
    field :sender, :integer

    timestamps()
  end

  @doc false
  def changeset(personmessage, attrs) do
    personmessage
    |> cast(attrs, [:sender, :receiver, :content])
    |> validate_required([:sender, :receiver, :content])
  end
end

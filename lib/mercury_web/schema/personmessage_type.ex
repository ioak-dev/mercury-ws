defmodule MercuryWeb.Schema.Types.PersonmessageType do
    use Absinthe.Schema.Notation
    alias Mercury.Repo

    object :personmessage do
        field :id, non_null(:id)
        field :sender, :string
        field :receiver, :string
        field :content, :string
    end

    object :personmessage_paginated do
        field :results, list_of(:personmessage)
        field :last_index, :integer
        field :has_more, :boolean
    end
end
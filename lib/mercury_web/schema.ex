defmodule MercuryWeb.Schema do
    use Absinthe.Schema

    alias MercuryWeb.AccountsResolver
    alias MercuryWeb.BlogResolver
    alias MercuryWeb.MessagestreamResolver

    import_types(MercuryWeb.Schema.Types)

    query do
        field :all_users, non_null(list_of(non_null(:user))) do
            resolve &AccountsResolver.all_users/3
        end
        field :user, :user do
            arg :id, non_null(:id)
            resolve &AccountsResolver.user/3
        end
        field :user_by_user_id, :user do
            arg :user_id, non_null(:id)
            resolve &AccountsResolver.user_by_user_id/3
        end
        field :all_posts, list_of(:post) do
            resolve &BlogResolver.all_posts/3
        end
        field :post, :post do
            arg :id, non_null(:id)
            resolve &BlogResolver.post/3
        end
        field :comments, list_of(:comment) do
            arg :post_id, non_null(:id)
            resolve &BlogResolver.comments/3
        end
        field :personmessages, :personmessage_paginated do
            arg :self_id, non_null(:id)
            arg :other_id, non_null(:id)
            arg :page_size, non_null(:integer)
            arg :last_index, non_null(:integer)
            resolve &MessagestreamResolver.personmessages/3
        end
    end

    mutation do
        field :create_user, :user do
            arg :payload, :user_input_type
            resolve &AccountsResolver.create_user/3
        end
        field :create_post, :post do
            arg :payload, :post_input_type
            resolve &BlogResolver.create_post/3
        end
        field :create_comment, :comment do
            arg :payload, :comment_input_type
            resolve &BlogResolver.create_comment/3
        end
    end
end
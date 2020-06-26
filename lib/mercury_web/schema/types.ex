defmodule MercuryWeb.Schema.Types do
    use Absinthe.Schema.Notation

    alias MercuryWeb.Schema.Types

    import_types(Types.UserType)
    import_types(Types.PostType)
    import_types(Types.CommentType)
end
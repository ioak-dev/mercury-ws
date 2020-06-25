defmodule AppnamehereWeb.Schema.Types do
    use Absinthe.Schema.Notation

    alias AppnamehereWeb.Schema.Types

    import_types(Types.UserType)
    import_types(Types.PostType)
    import_types(Types.CommentType)
end
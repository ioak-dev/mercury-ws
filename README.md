# Mercury

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Migrate ecto for each space by running `mix ecto.migrate --prefix mercury_<spaceid>`
- Start Phoenix endpoint with `mix phx.server`
- Generate a new domain (comment) in the context (Blog) with the plural database name (comments) `mix phx.gen.json Blog Comment comments description:text post_id:references:posts user_id:references:users`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Graph QL Query example

`{ allUsers { id firstName posts { description } } allPosts { description id user { id firstName lastName email userId } } user(id: "7") { email } userByUserId(userId: "5ec7756eeac57601b53acb51") { id } post(id: "4") { description } }`

`{ comments(postId: "4") { description id user { email } post { description } } }`

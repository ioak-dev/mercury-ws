defmodule Appnamehere.Repo do
  use Ecto.Repo,
    otp_app: :appnamehere,
    adapter: Ecto.Adapters.Postgres
end

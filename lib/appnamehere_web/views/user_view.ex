defmodule AppnamehereWeb.UserView do
  use AppnamehereWeb, :view
  alias AppnamehereWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("session.json", %{user: user, token: token}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      user_id: user.user_id,
      type: user.type,
      token: token
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      user_id: user.user_id,
      type: user.type}
  end
end

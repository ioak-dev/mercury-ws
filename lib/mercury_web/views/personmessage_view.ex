defmodule MercuryWeb.PersonmessageView do
  use MercuryWeb, :view
  alias MercuryWeb.PersonmessageView

  def render("index.json", %{personmessages: personmessages}) do
    %{data: render_many(personmessages, PersonmessageView, "personmessage.json")}
  end

  def render("show.json", %{personmessage: personmessage}) do
    %{data: render_one(personmessage, PersonmessageView, "personmessage.json")}
  end

  def render("personmessage.json", %{personmessage: personmessage}) do
    %{id: personmessage.id,
      sender: personmessage.sender,
      receiver: personmessage.receiver,
      content: personmessage.content}
  end
end

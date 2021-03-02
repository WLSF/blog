defmodule BlogWeb.SessionView do
  use BlogWeb, :view

  alias BlogWeb.SessionView

  def render("login.json", %{token: token}) do
    %{data: render_one(token, SessionView, "token.json")}
  end

  def render("token.json", %{session: token}) do
    %{token: token}
  end
end

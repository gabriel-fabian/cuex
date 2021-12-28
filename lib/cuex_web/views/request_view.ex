defmodule CuexWeb.RequestView do
  use CuexWeb, :view
  alias CuexWeb.RequestView

  def render("index.json", %{requests: requests}) do
    %{data: render_many(requests, RequestView, "request.json")}
  end

  def render("show.json", %{request: request}) do
    %{data: render_one(request, RequestView, "request.json")}
  end

  def render("request.json", %{request: request}) do
    %{
      id: request.id,
      user_id: request.user_id,
      from_currency: request.from_currency,
      to_currency: request.to_currency,
      value: request.value,
      conversion_rate: request.conversion_rate
    }
  end
end

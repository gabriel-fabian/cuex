defmodule CuexWeb.ConvertView do
  use CuexWeb, :view
  alias CuexWeb.ConvertView

  def render("show.json", %{convert: convert}) do
    %{data: render_one(convert, ConvertView, "request.json")}
  end

  def render("request.json", %{convert: convert}) do
    %{
      id: convert.id,
      user_id: convert.user_id,
      from_currency: convert.from_currency,
      to_currency: convert.to_currency,
      value: convert.value,
      converted_value: convert.converted_value,
      conversion_rate: convert.conversion_rate,
      date: convert.inserted_at
    }
  end
end

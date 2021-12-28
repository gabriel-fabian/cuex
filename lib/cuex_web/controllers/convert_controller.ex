defmodule CuexWeb.ConvertController do
  use CuexWeb, :controller

  alias Cuex.Converter

  action_fallback CuexWeb.FallbackController

  def convert_currency(conn, params) do
    with {:ok, response} <- Converter.convert_currency(params) do
      render(conn, "show.json", convert: response)
    end
  end
end

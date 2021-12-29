defmodule CuexWeb.ConvertController do
  use CuexWeb, :controller

  require Logger

  alias Cuex.Converter

  action_fallback CuexWeb.FallbackController

  def convert_currency(conn, params) do
    Logger.info("ConvertController | Received request with params=#{inspect(params)}")

    with {:ok, response} <- Converter.convert_currency(params) do
      render(conn, "show.json", convert: response)
    else
      {:error, response} ->
        conn
        |> put_status(response.status_code)
        |> put_view(CuexWeb.ErrorView)
        |> render("error.json", %{status_code: response.status_code, body: response.body})
    end
  end
end

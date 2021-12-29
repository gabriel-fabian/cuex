defmodule CuexWeb.ConvertController do
  use CuexWeb, :controller

  require Logger

  alias Cuex.Converter

  action_fallback CuexWeb.FallbackController

  def convert_currency(
        conn,
        params = %{
          "from_currency" => _from_currency,
          "to_currency" => _to_currency,
          "value" => _value,
          "user_id" => _user_id
        }
      ) do
    Logger.info("ConvertController | Received request with params=#{inspect(params)}")

    with {:ok, response} <- Converter.convert_currency(params) do
      render(conn, "show.json", convert: response)
    else
      {:error, response} ->
        conn
        |> put_status(response.status_code)
        |> put_view(CuexWeb.ErrorView)
        |> render(:"#{response.status_code}")
    end
  end

  def convert_currency(conn, params) do
    Logger.info("ConvertController | Received request with invalid params=#{inspect(params)}")

    conn
    |> put_status(:bad_request)
    |> put_view(CuexWeb.ErrorView)
    |> render(:"400")
  end
end

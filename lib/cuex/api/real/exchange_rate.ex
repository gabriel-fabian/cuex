defmodule Cuex.Api.Real.ExchangeRate do
  @moduledoc """
  A module to make requests to ExchangeRateApi and retrieve exchange_rates
  """

  @config Application.compile_env(:cuex, :exchangerate)
  @url @config[:url]
  @api_key @config[:api_key]

  require Logger

  def fetch_rates do
    @url
    |> HTTPoison.get(
      headers(),
      params: access_key_param()
    )
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info("ExchangeRateApi | Received exchange rates")

    {:ok, Poison.decode!(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    Logger.info("ExchangeRateApi | Api returned a non 200 status code")

    {:error, %{status_code: status_code, body: Poison.decode!(body)}}
  end

  defp handle_response({:error, response}) do
    Logger.info("ExchangeRateApi | Failed to make request. response: #{inspect(response)}")

    {:error, %{status_code: response.status_code, body: Poison.decode!(response.body)}}
  end

  defp headers do
    [{"Content-Type", "application/json"}]
  end

  defp access_key_param do
    %{access_key: @api_key}
  end
end

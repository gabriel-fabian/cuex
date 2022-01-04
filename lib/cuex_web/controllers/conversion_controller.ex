defmodule CuexWeb.ConversionController do
  use CuexWeb, :controller

  require Logger

  alias Cuex.Conversion

  action_fallback CuexWeb.FallbackController

  def index(conn, %{"user_id" => user_id, "page" => page, "page_size" => page_size}) do
    Logger.info("ConversionController | Received show, user_id=#{user_id}")

    user_id
    |> Conversion.get_conversions_from_user(page, page_size)
    |> render_index(conn)
  end

  def index(conn, %{"user_id" => user_id}) do
    Logger.info("ConversionController | Received show, user_id=#{user_id}")

    user_id
    |> Conversion.get_conversions_from_user()
    |> render_index(conn)
  end

  def index(conn, %{"page" => page, "page_size" => page_size}) do
    Logger.info("ConversionController | Received index call")

    page
    |> Conversion.list_conversions(page_size)
    |> render_index(conn)
  end

  def index(conn, _params) do
    Logger.info("ConversionController | Received index call")

    render_index(Conversion.list_conversions(), conn)
  end

  def create(conn, params) do
    Logger.info("ConversionController | Received request with params=#{inspect(params)}")

    case Conversion.convert_currency(params) do
      {:ok, response} ->
        render(conn, "show.json", conversion: response)

      error ->
        error
    end
  end

  defp render_index(conversion_histories, conn) do
    render(conn, "index.json", conversion_histories: conversion_histories)
  end
end

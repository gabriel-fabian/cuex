defmodule CuexWeb.ConversionController do
  use CuexWeb, :controller

  require Logger

  alias Cuex.Conversion

  action_fallback CuexWeb.FallbackController

  def index(conn, %{"user_id" => user_id, "page" => page, "page_size" => page_size}) do
    Logger.info("ConversionController | Received show, user_id=#{user_id}")

    conversion_histories = Conversion.get_conversions_from_user(user_id, page, page_size)
    render(conn, "index.json", conversion_histories: conversion_histories)
  end

  def index(conn, %{"user_id" => user_id}) do
    Logger.info("ConversionController | Received show, user_id=#{user_id}")

    conversion_histories = Conversion.get_conversions_from_user(user_id)
    render(conn, "index.json", conversion_histories: conversion_histories)
  end

  def index(conn, %{"page" => page, "page_size" => page_size}) do
    Logger.info("ConversionController | Received index call")

    conversion_histories = Conversion.list_conversions(page, page_size)
    render(conn, "index.json", conversion_histories: conversion_histories)
  end

  def index(conn, _params) do
    Logger.info("ConversionController | Received index call")

    conversion_histories = Conversion.list_conversions()
    render(conn, "index.json", conversion_histories: conversion_histories)
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
end

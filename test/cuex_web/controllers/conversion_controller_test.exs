defmodule CuexWeb.ConversionControllerTest do
  use CuexWeb.ConnCase

  import Cuex.ConversionFixtures
  import Ecto.Query

  alias Cuex.Conversion.ConversionHistory
  alias Cuex.{Conversion, Repo}

  @create_attrs %{
    "conversion_rate" => 120.5,
    "from_currency" => "some_from_currency",
    "to_currency" => "some_to_currency",
    "user_id" => 42,
    "value" => 120.5
  }

  @valid_params %{
    "from_currency" => "EUR",
    "to_currency" => "USD",
    "value" => 10,
    "user_id" => 1
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}

    fixture(:conversion_history, @create_attrs)
    fixture(:conversion_history, Map.merge(@create_attrs, %{"user_id" => 43}))
    fixture(:conversion_history, @create_attrs)

    conversion_fixtures_count = 3

    %{
      first_user_id: 42,
      second_user_id: 43,
      conversion_fixtures_count: conversion_fixtures_count
    }
  end

  describe "index" do
    test "lists all conversion histories", %{conn: conn} do
      conn = get(conn, Routes.conversion_path(conn, :index))
      response_data = json_response(conn, 200)["data"]

      assert response_data == index_response()
      assert Enum.count(response_data) == 3
    end
  end

  describe "show/2" do
    test "lists all conversions from user", %{conn: conn, first_user_id: user_id} do
      conn = get(conn, Routes.conversion_path(conn, :show, user_id))
      response_data = json_response(conn, 200)["data"]

      assert response_data == conversions_from_user_response(user_id)
      assert Enum.count(response_data) == 2
    end
  end

  describe "create/2" do
    test "with valid params returns a converted value and create conversion history", %{
      conn: conn,
      conversion_fixtures_count: conversion_fixtures_count
    } do
      conn = post(conn, Routes.conversion_path(conn, :create), @valid_params)
      response_data = json_response(conn, 200)["data"]

      conversion_history = get_last_conversion_history()

      assert Enum.count(Conversion.list_conversions()) == conversion_fixtures_count + 1
      assert response_data == convert_currency_response(conversion_history)
    end

    test "with invalid params returns an error", %{conn: conn} do
      conn = post(conn, Routes.conversion_path(conn, :create), nil)
      response_data = json_response(conn, 400)["errors"]

      assert response_data == %{
               "detail" => "Bad Request",
               "response" =>
                 "Invalid params provided, missing params=[\"from_currency\", \"to_currency\", \"value\", \"user_id\"]"
             }
    end
  end

  def get_last_conversion_history do
    Repo.one(from ch in ConversionHistory, order_by: [desc: ch.id], limit: 1)
  end

  defp index_response do
    conversions = Conversion.list_conversions()

    Enum.map(conversions, fn converion ->
      %{
        "conversion_rate" => converion.conversion_rate,
        "from_currency" => converion.from_currency,
        "id" => converion.id,
        "to_currency" => converion.to_currency,
        "user_id" => converion.user_id,
        "value" => converion.value
      }
    end)
  end

  defp conversions_from_user_response(user_id) do
    conversions = Conversion.get_conversions_from_user(user_id)

    Enum.map(conversions, fn conversion ->
      %{
        "conversion_rate" => conversion.conversion_rate,
        "from_currency" => conversion.from_currency,
        "id" => conversion.id,
        "to_currency" => conversion.to_currency,
        "user_id" => conversion.user_id,
        "value" => conversion.value
      }
    end)
  end

  defp convert_currency_response(conversion_history) do
    converted_value = conversion_history.value * conversion_history.conversion_rate
    date = Calendar.strftime(conversion_history.inserted_at, "%Y-%m-%dT%H:%M:%S")

    %{
      "conversion_rate" => conversion_history.conversion_rate,
      "converted_value" => converted_value,
      "date" => date,
      "from_currency" => conversion_history.from_currency,
      "id" => conversion_history.id,
      "to_currency" => conversion_history.to_currency,
      "user_id" => conversion_history.user_id,
      "value" => conversion_history.value
    }
  end
end

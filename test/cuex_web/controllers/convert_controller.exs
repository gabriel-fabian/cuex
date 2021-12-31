defmodule CuexWeb.ConvertControllerTest do
  use CuexWeb.ConnCase

  import Ecto.Query

  alias Cuex.Converter.Request
  alias Cuex.{Converter, Repo}

  @valid_params %{
    "from_currency" => "EUR",
    "to_currency" => "USD",
    "value" => 10,
    "user_id" => 1
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "convert_currency/2" do
    test "with valid params returns a converted value and create request", %{conn: conn} do
      conn = post(conn, Routes.convert_path(conn, :convert_currency), @valid_params)
      response_data = json_response(conn, 200)["data"]

      request = get_last_request()

      assert Enum.count(Converter.list_requests()) == 1
      assert response_data == expected_response(request)
    end

    test "with invalid params returns an error", %{conn: conn} do
      conn = post(conn, Routes.convert_path(conn, :convert_currency), nil)
      response_data = json_response(conn, 400)["errors"]

      assert response_data == %{
               "detail" => "Bad Request",
               "response" => "Invalid params provided, params=%{}"
             }
    end
  end

  def get_last_request do
    Repo.one(from(r in Request, limit: 1, order_by: [desc: r.inserted_at]))
  end

  defp expected_response(request) do
    converted_value = request.value * request.conversion_rate
    date = Calendar.strftime(request.inserted_at, "%Y-%m-%dT%H:%M:%S")

    %{
      "conversion_rate" => request.conversion_rate,
      "converted_value" => converted_value,
      "date" => date,
      "from_currency" => request.from_currency,
      "id" => request.id,
      "to_currency" => request.to_currency,
      "user_id" => request.user_id,
      "value" => request.value
    }
  end
end

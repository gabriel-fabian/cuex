defmodule CuexWeb.RequestControllerTest do
  use CuexWeb.ConnCase

  import Cuex.ConverterFixtures

  alias Cuex.Converter

  @create_attrs %{
    "conversion_rate" => 120.5,
    "from_currency" => "some_from_currency",
    "to_currency" => "some_to_currency",
    "user_id" => 42,
    "value" => 120.5
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}

    fixture(:request, @create_attrs)
    fixture(:request, Map.merge(@create_attrs, %{"user_id" => 43}))
    fixture(:request, @create_attrs)

    %{
      first_user_id: 42,
      second_user_id: 43
    }
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      expected_response = index_response()

      conn = get(conn, Routes.request_path(conn, :index))
      response_data = json_response(conn, 200)["data"]

      assert response_data == expected_response
      assert Enum.count(response_data) == 3
    end
  end

  describe "show_requests_from_user/2" do
    test "lists all requests from user", %{conn: conn, first_user_id: user_id} do
      expected_response = requests_from_user_response(user_id)

      conn = get(conn, Routes.request_path(conn, :show_requests_from_user, user_id))
      response_data = json_response(conn, 200)["data"]

      assert response_data == expected_response
      assert Enum.count(response_data) == 2
    end
  end

  defp index_response() do
    requests = Converter.list_requests()

    Enum.map(requests, fn request ->
      %{
        "conversion_rate" => request.conversion_rate,
        "from_currency" => request.from_currency,
        "id" => request.id,
        "to_currency" => request.to_currency,
        "user_id" => request.user_id,
        "value" => request.value
      }
    end)
  end

  defp requests_from_user_response(user_id) do
    requests = Converter.get_requests_from_user(user_id)

    Enum.map(requests, fn request ->
      %{
        "conversion_rate" => request.conversion_rate,
        "from_currency" => request.from_currency,
        "id" => request.id,
        "to_currency" => request.to_currency,
        "user_id" => request.user_id,
        "value" => request.value
      }
    end)
  end
end

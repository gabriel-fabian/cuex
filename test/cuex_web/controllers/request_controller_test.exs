defmodule CuexWeb.RequestControllerTest do
  use CuexWeb.ConnCase

  import Cuex.ConverterFixtures

  alias Cuex.Converter.Request

  @create_attrs %{
    conversion_rate: 120.5,
    from_currency: "some from_currency",
    to_currency: "some to_currency",
    user_id: 42,
    value: 120.5
  }
  @update_attrs %{
    conversion_rate: 456.7,
    from_currency: "some updated from_currency",
    to_currency: "some updated to_currency",
    user_id: 43,
    value: 456.7
  }
  @invalid_attrs %{
    conversion_rate: nil,
    from_currency: nil,
    to_currency: nil,
    user_id: nil,
    value: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.request_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "conversion_rate" => 120.5,
               "from_currency" => "some from_currency",
               "to_currency" => "some to_currency",
               "user_id" => 42,
               "value" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request} do
      conn = put(conn, Routes.request_path(conn, :update, request), request: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.request_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "conversion_rate" => 456.7,
               "from_currency" => "some updated from_currency",
               "to_currency" => "some updated to_currency",
               "user_id" => 43,
               "value" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, request: request} do
      conn = put(conn, Routes.request_path(conn, :update, request), request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request" do
    setup [:create_request]

    test "deletes chosen request", %{conn: conn, request: request} do
      conn = delete(conn, Routes.request_path(conn, :delete, request))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.request_path(conn, :show, request))
      end
    end
  end

  defp create_request(_) do
    request = request_fixture()
    %{request: request}
  end
end

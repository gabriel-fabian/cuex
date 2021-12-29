defmodule Cuex.ConverterTest do
  use Cuex.DataCase

  alias Cuex.Converter

  describe "requests" do
    alias Cuex.Converter.Request

    import Cuex.ConverterFixtures

    @invalid_attrs %{
      "conversion_rate" => nil,
      "from_currency" => nil,
      "to_currency" => nil,
      "user_id" => nil,
      "value" => nil
    }

    @valid_attrs %{
      "conversion_rate" => 120.5,
      "from_currency" => "some_from_currency",
      "to_currency" => "some_to_currency",
      "user_id" => 42,
      "value" => 120.5
    }

    setup do
      first_request = fixture(:request, @valid_attrs)
      second_request = fixture(:request, Map.merge(@valid_attrs, %{"user_id" => 43}))
      third_request = fixture(:request, @valid_attrs)

      %{
        user_id: 42,
        first_request: first_request,
        second_request: second_request,
        third_request: third_request
      }
    end

    test "list_requests/0 returns all requests", %{
      first_request: first_request,
      second_request: second_request,
      third_request: third_request
    } do
      assert Converter.list_requests() == [first_request, second_request, third_request]
    end

    test "get_request!/1 returns the request with given id" do
      request = fixture(:request)
      assert Converter.get_request!(request.id) == request
    end

    test "get_request_from_user/1 returns all request from user", %{
      user_id: user_id,
      first_request: first_request,
      third_request: third_request
    } do
      assert Converter.get_requests_from_user(user_id) == [first_request, third_request]
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Converter.create_request(@valid_attrs)
      assert request.conversion_rate == @valid_attrs["conversion_rate"]
      assert request.from_currency == @valid_attrs["from_currency"]
      assert request.to_currency == @valid_attrs["to_currency"]
      assert request.user_id == @valid_attrs["user_id"]
      assert request.value == @valid_attrs["value"]
    end

    test "create_request/2 with valid data creates a request" do
      modified_attrs = Map.delete(@valid_attrs, "conversion_rate")

      assert {:ok, %Request{} = request} = Converter.create_request(modified_attrs, 42.5)
      assert request.conversion_rate == 42.5
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Converter.create_request(@invalid_attrs)
    end
  end
end

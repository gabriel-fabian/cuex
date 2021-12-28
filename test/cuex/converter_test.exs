defmodule Cuex.ConverterTest do
  use Cuex.DataCase

  alias Cuex.Converter

  describe "requests" do
    alias Cuex.Converter.Request

    import Cuex.ConverterFixtures

    @invalid_attrs %{
      conversion_rate: nil,
      from_currency: nil,
      to_currency: nil,
      user_id: nil,
      value: nil
    }

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Converter.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Converter.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      valid_attrs = %{
        conversion_rate: 120.5,
        from_currency: "some from_currency",
        to_currency: "some to_currency",
        user_id: 42,
        value: 120.5
      }

      assert {:ok, %Request{} = request} = Converter.create_request(valid_attrs)
      assert request.conversion_rate == 120.5
      assert request.from_currency == "some from_currency"
      assert request.to_currency == "some to_currency"
      assert request.user_id == 42
      assert request.value == 120.5
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Converter.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()

      update_attrs = %{
        conversion_rate: 456.7,
        from_currency: "some updated from_currency",
        to_currency: "some updated to_currency",
        user_id: 43,
        value: 456.7
      }

      assert {:ok, %Request{} = request} = Converter.update_request(request, update_attrs)
      assert request.conversion_rate == 456.7
      assert request.from_currency == "some updated from_currency"
      assert request.to_currency == "some updated to_currency"
      assert request.user_id == 43
      assert request.value == 456.7
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Converter.update_request(request, @invalid_attrs)
      assert request == Converter.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Converter.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Converter.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Converter.change_request(request)
    end
  end
end

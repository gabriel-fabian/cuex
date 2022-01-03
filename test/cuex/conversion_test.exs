defmodule Cuex.ConversionTest do
  use Cuex.DataCase

  alias Cuex.Conversion

  describe "conversion_histories" do
    alias Cuex.Conversion.ConversionHistory

    import Cuex.ConversionFixtures

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
      first_conversion_history = fixture(:conversion_history, @valid_attrs)

      second_conversion_history =
        fixture(:conversion_history, Map.merge(@valid_attrs, %{"user_id" => 43}))

      third_conversion_history = fixture(:conversion_history, @valid_attrs)

      %{
        user_id: 42,
        first_conversion_history: first_conversion_history,
        second_conversion_history: second_conversion_history,
        third_conversion_history: third_conversion_history
      }
    end

    test "list_conversions/0 returns all conversions", %{
      first_conversion_history: first_conversion_history,
      second_conversion_history: second_conversion_history,
      third_conversion_history: third_conversion_history
    } do
      assert Conversion.list_conversions() == [
               first_conversion_history,
               second_conversion_history,
               third_conversion_history
             ]
    end

    test "get_conversions_from_user/1 returns all conversions from user", %{
      user_id: user_id,
      first_conversion_history: first_conversion_history,
      third_conversion_history: third_conversion_history
    } do
      assert Conversion.get_conversions_from_user(user_id) == [
               first_conversion_history,
               third_conversion_history
             ]
    end

    test "create_conversion_history/1 with valid data creates a conversion_history" do
      assert {:ok, %ConversionHistory{} = conversion_history} =
               Conversion.create_conversion_history(@valid_attrs)

      assert conversion_history.conversion_rate == @valid_attrs["conversion_rate"]
      assert conversion_history.from_currency == @valid_attrs["from_currency"]
      assert conversion_history.to_currency == @valid_attrs["to_currency"]
      assert conversion_history.user_id == @valid_attrs["user_id"]
      assert conversion_history.value == @valid_attrs["value"]
    end

    test "create_conversion_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversion.create_conversion_history(@invalid_attrs)
    end
  end

  describe "convert_currency/1" do
    @valid_params %{
      "from_currency" => "EUR",
      "to_currency" => "USD",
      "value" => 10,
      "user_id" => 1
    }

    test "with valid params returns converted value" do
      assert {:ok, response} = Conversion.convert_currency(@valid_params)
      assert response.from_currency == "EUR"
      assert response.to_currency == "USD"
      assert response.value == 10
      assert response.converted_value == 11.33768
      assert response.user_id == 1
    end

    test "when value is not a number returns an changeset error" do
      invalid_params = Map.merge(@valid_params, %{"value" => "not_a_number"})

      assert {:error, %Ecto.Changeset{}} = Conversion.convert_currency(invalid_params)
    end

    test "when value is lower or equal than 0 returns an error" do
      invalid_params = Map.merge(@valid_params, %{"value" => 0})

      assert {:error, response} = Conversion.convert_currency(invalid_params)

      assert response == %{
               body: "Invalid value provided, must be greather than 0",
               status_code: 400
             }
    end

    test "when currency is not valid returns an error" do
      invalid_params = Map.merge(@valid_params, %{"from_currency" => "FOO"})

      assert {:error, response} = Conversion.convert_currency(invalid_params)
      assert response == %{body: "Invalid currency type provided. Currency=FOO", status_code: 400}
    end

    test "with params missing returns an error" do
      assert {:error, response} = Conversion.convert_currency(nil)

      assert response == %{
               body:
                 "Invalid params provided, missing params=[\"from_currency\", \"to_currency\", \"value\", \"user_id\"]",
               status_code: 400
             }
    end
  end
end

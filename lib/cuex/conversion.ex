defmodule Cuex.Conversion do
  @moduledoc """
  The Conversion context.
  """

  @exchange_api Application.compile_env(:cuex, :exchangerate)[:api]

  import Ecto.Query, warn: false

  require Logger

  alias Cuex.Conversion.ConversionHistory
  alias Cuex.Repo

  @doc """
  Returns the list of ConversionHistory.

  ## Examples

      iex> list_conversions()
      [%ConversionHistory{}, ...]

  """
  def list_conversions do
    Repo.all(ConversionHistory)
  end

  @doc """
  Returns the list of conversions for a given user_id

  ## Examples

      iex> get_conversions_from_user(2)
      [%ConversionHistory{}, ...]
  """
  def get_conversions_from_user(user_id) do
    ConversionHistory
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a conversion_history.

  ## Examples

      iex> create_conversion_history(%{field: value})
      {:ok, %ConversionHistory{}}

      iex> create_conversion_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversion_history(attrs \\ %{}) do
    %ConversionHistory{}
    |> ConversionHistory.changeset(attrs)
    |> Repo.insert()
  end

  defp create_conversion_history(attrs, conversion_rate) when is_map(attrs) do
    attrs
    |> Map.merge(%{"conversion_rate" => conversion_rate})
    |> create_conversion_history()
  end

  defp create_conversion_history(attrs, _) do
    Logger.info(
      "Conversion | create_conversion_history/2 received invalid attrs, attrs=#{inspect(attrs)}"
    )

    {:error, %{status_code: 500, body: "Internal server error"}}
  end

  def convert_currency(
        %{
          "from_currency" => from_currency,
          "to_currency" => to_currency,
          "value" => value,
          "user_id" => _user_id
        } = params
      ) do
    with {:ok, response} <- fetch_api_exchange_rates(),
         {:ok, euro_exchange_rates} <-
           get_euro_exchange_rates(response["rates"], from_currency, to_currency),
         {:ok, converted_value} <- convert_values(euro_exchange_rates, value),
         {:ok, conversion_rate} <- get_conversion_rate(value, converted_value),
         {:ok, saved_conversion} <- create_conversion_history(params, conversion_rate),
         {:ok, response} <- handle_response(saved_conversion, converted_value) do
      {:ok, response}
    else
      {:error, response} ->
        {:error, response}

      _ ->
        {:error, %{status_code: 500, body: "Internal server error"}}
    end
  end

  def convert_currency(params) do
    Logger.info("Conversion | Received request with invalid params=#{inspect(params)}")

    {:error,
     %{
       status_code: 400,
       body: "Invalid params provided, missing params=#{inspect(missing_params(params))}"
     }}
  end

  defp get_euro_exchange_rates(rates, from_currency, to_currency) do
    with {true, _} <- is_valid_currency?(rates, from_currency),
         {true, _} <- is_valid_currency?(rates, to_currency) do
      {:ok, {rates[from_currency], rates[to_currency]}}
    else
      {false, currency} ->
        Logger.info("Conversion | Fail to convert. Invalid currency type received")

        {:error,
         %{
           status_code: 400,
           body: "Invalid currency type provided. Currency=#{currency}"
         }}
    end
  end

  defp is_valid_currency?(rates, currency),
    do: {is_integer(rates[currency]) or is_float(rates[currency]), currency}

  defp convert_values({from_rate, to_rate}, value) when is_integer(value) or is_float(value),
    do: {:ok, value / from_rate * to_rate}

  defp convert_values(_, value) do
    Logger.info("Conversion | Fail to convert. Value, #{value}, is not a number")

    {:error, %{status_code: 400, body: "Value #{value} is not a number"}}
  end

  defp get_conversion_rate(value, converted_value), do: {:ok, converted_value / value}

  defp fetch_api_exchange_rates do
    @exchange_api.fetch_rates()
  end

  defp missing_params(params) do
    required_fields = ["from_currency", "to_currency", "value", "user_id"]

    Enum.reject(required_fields, fn field -> params[field] end)
  end

  defp handle_response(%ConversionHistory{} = saved_conversion, converted_value),
    do: {:ok, Map.merge(saved_conversion, %{converted_value: converted_value})}

  defp handle_response(_, _) do
    Logger.error("Conversion | Failed to save conversion_history to database")

    {:error, %{status_code: 422, body: "Failed to save conversion_history into database"}}
  end
end

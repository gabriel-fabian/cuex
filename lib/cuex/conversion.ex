defmodule Cuex.Conversion do
  @moduledoc """
  The Conversion context.
  """

  @exchange_api Application.compile_env(:cuex, :exchangerate)[:api]

  import Ecto.Query, warn: false

  require Logger

  alias Cuex.Conversion.{ConversionHistory, Formalization}
  alias Cuex.Repo
  alias Ecto.Changeset

  @doc """
  Convert the given currencies based on Euro exchange rates and save the request to ConversionHistory in database.

  ## Examples

      iex> convert_currency(
        %{
          "from_currency" => "BRL",
          "to_currency" => "USD",
          "value" => 20,
          "user_id" => 4
        }
      )
      {:ok, %ConversionHistory{}}

  """
  def convert_currency(
        %{
          "from_currency" => from_currency,
          "to_currency" => to_currency,
          "value" => _value,
          "user_id" => _user_id
        } = params
      ) do
    with {:ok, parsed_params} <- parse_params(params),
         {true, value} <- is_valid_value?(parsed_params.value),
         {:ok, response} <- @exchange_api.fetch_rates(),
         {:ok, base_currency_exchange_rates} <-
           get_base_currency_exchange_rate(response["rates"], from_currency, to_currency),
         {:ok, converted_value} <- convert_values(base_currency_exchange_rates, value),
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

  @doc """
  Returns the list of ConversionHistory.

  ## Examples

      iex> list_conversions()
      [%ConversionHistory{}, ...]

  """
  def list_conversions do
    Repo.all(ConversionHistory)
  end

  def list_conversions(page, page_size) do
    ConversionHistory
    |> order_by(desc: :id)
    |> Repo.paginate(page: page, page_size: page_size)
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

  def get_conversions_from_user(user_id, page, page_size) do
    ConversionHistory
    |> where(user_id: ^user_id)
    |> order_by(desc: :id)
    |> Repo.paginate(page: page, page_size: page_size)
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

  defp create_conversion_history(attrs, conversion_rate) do
    attrs
    |> Map.merge(%{"conversion_rate" => conversion_rate})
    |> create_conversion_history()
  end

  defp parse_params(params) do
    changeset = Formalization.changeset(params)

    case changeset do
      %Changeset{valid?: true, changes: changes} ->
        {:ok, changes}

      changeset ->
        {:error, changeset}
    end
  end

  defp is_valid_value?(value) when value > 0, do: {true, value}

  defp is_valid_value?(_),
    do: {:error, %{status_code: 400, body: "Invalid value provided, must be greather than 0"}}

  defp get_base_currency_exchange_rate(rates, from_currency, to_currency) do
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

  defp convert_values({from_rate, to_rate}, value),
    do: {:ok, value / from_rate * to_rate}

  defp get_conversion_rate(value, converted_value), do: {:ok, converted_value / value}

  defp missing_params(params) do
    required_fields = ["from_currency", "to_currency", "value", "user_id"]

    Enum.reject(required_fields, fn field -> params[field] end)
  end

  defp handle_response(%ConversionHistory{} = saved_conversion, converted_value),
    do: {:ok, Map.merge(saved_conversion, %{converted_value: converted_value})}
end

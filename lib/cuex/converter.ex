defmodule Cuex.Converter do
  @moduledoc """
  The Converter context.
  """

  @exchange_api Application.get_env(:cuex, :exchangerate)[:api]

  import Ecto.Query, warn: false

  require Logger

  alias Cuex.Converter.Request
  alias Cuex.Repo

  @doc """
  Returns the list of requests.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests do
    Repo.all(Request)
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id), do: Repo.get!(Request, id)

  @doc """
  Returns the list of requests for a given user_id

  ## Examples

      iex> get_requests_from_user(2)
      [%Request{}, ...]
  """
  def get_requests_from_user(user_id) do
    Request
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def create_request(attrs, conversion_rate) when is_map(attrs) do
    attrs
    |> Map.merge(%{"conversion_rate" => conversion_rate})
    |> create_request()
  end

  def create_request(attrs, _) do
    Logger.info("Converter | create_request/2 received invalid attrs, attrs=#{inspect(attrs)}")

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
    with {:ok, response} <- fetch_exchange_rate(),
         {:ok, exchange_rates} <-
           get_euro_exchange_rates(response["rates"], from_currency, to_currency),
         {:ok, converted_value} <- convert_values(exchange_rates, value),
         {:ok, conversion_rate} <- get_conversion_rate(value, converted_value),
         {:ok, saved_request} <- create_request(params, conversion_rate),
         {:ok, response} <- handle_response(saved_request, converted_value) do
      {:ok, response}
    else
      {:error, response} ->
        {:error, response}

      _ ->
        {:error, %{status_code: 500, body: "Internal server error"}}
    end
  end

  def convert_currency(params) do
    Logger.info("Converter | Received request with invalid params=#{inspect(params)}")

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
        Logger.info("Converter | Fail to convert. Invalid currency type received")

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
    Logger.info("Converter | Fail to convert. Value, #{value}, is not a number")

    {:error, %{status_code: 400, body: "Value #{value} is not a number"}}
  end

  defp get_conversion_rate(value, converted_value), do: {:ok, converted_value / value}

  defp handle_response(%Request{} = request, converted_value),
    do: {:ok, Map.merge(request, %{converted_value: converted_value})}

  defp handle_response(_, _) do
    Logger.info("Converter | Failed to save request to database")

    {:error, %{status_code: 500, body: "Failed to save request into database"}}
  end

  defp fetch_exchange_rate() do
    @exchange_api.fetch_rates()
  end

  defp missing_params(params) do
    required_fields = ["from_currency", "to_currency", "value", "user_id"]

    Enum.reject(required_fields, fn field -> params[field] end)
  end
end

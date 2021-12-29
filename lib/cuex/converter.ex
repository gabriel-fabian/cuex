defmodule Cuex.Converter do
  @moduledoc """
  The Converter context.
  """

  import Ecto.Query, warn: false
  alias Cuex.Repo

  alias Cuex.Converter.Request

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

  def create_request(attrs, conversion_rate) do
    attrs
    |> Map.merge(%{"conversion_rate" => conversion_rate})
    |> create_request()
  end

  def convert_currency(
        params = %{
          "from_currency" => from_currency,
          "to_currency" => to_currency,
          "value" => value,
          "user_id" => _user_id
        }
      ) do
    with {:ok, response} <- mocked_api_response(),
         exchange_rates <- get_euro_exchange_rates(response["rates"], from_currency, to_currency),
         converted_value <- convert_values(exchange_rates, value),
         conversion_rate <- get_conversion_rate(value, converted_value),
         {:ok, saved_request} <- create_request(params, conversion_rate),
         {:ok, response} <- handle_response(saved_request, converted_value) do
      {:ok, response}
    end
  end

  defp get_euro_exchange_rates(rates, from_currency, to_currency),
    do: {rates[from_currency], rates[to_currency]}

  defp convert_values({from_rate, to_rate}, value),
    do: value / from_rate * to_rate

  defp get_conversion_rate(value, converted_value), do: converted_value / value

  defp handle_response(%Request{} = request, converted_value),
    do: {:ok, Map.merge(request, %{converted_value: converted_value})}

  defp mocked_api_response() do
    {:ok,
     %{
       "base" => "EUR",
       "date" => "2021-12-28",
       "rates" => %{"BRL" => 6.385356, "USD" => 1.130959, "EUR" => 1, "JPY" => 129.786081},
       "success" => true,
       "timestamp" => 1_640_714_344
     }}
  end
end

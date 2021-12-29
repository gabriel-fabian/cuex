defmodule Cuex.ConverterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cuex.Converter` context.
  """

  @doc """
  Generate a request.
  """
  def fixture(:request, attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{
        "conversion_rate" => 120.5,
        "from_currency" => "test_from_currency",
        "to_currency" => "test_to_currency",
        "user_id" => 42,
        "value" => 120.5
      })
      |> Cuex.Converter.create_request()

    request
  end
end

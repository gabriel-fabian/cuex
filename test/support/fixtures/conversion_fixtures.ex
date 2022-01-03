defmodule Cuex.ConversionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cuex.Converter` context.
  """

  @doc """
  Generate a conversion_history.
  """

  alias Cuex.Conversion

  def fixture(:conversion_history, attrs \\ %{}) do
    {:ok, conversion_history} =
      attrs
      |> Enum.into(%{
        "conversion_rate" => 120.5,
        "from_currency" => "test_from_currency",
        "to_currency" => "test_to_currency",
        "user_id" => 42,
        "value" => 120.5
      })
      |> Conversion.create_conversion_history()

    conversion_history
  end
end

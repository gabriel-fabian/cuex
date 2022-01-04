defmodule Cuex.ConversionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cuex.Converter` context.
  """

  @doc """
  Generate a conversion_history.
  """

  alias Cuex.Conversion.ConversionHistory
  alias Cuex.Repo

  def fixture(:conversion_history, attrs) do
    %ConversionHistory{}
    |> ConversionHistory.changeset(attrs)
    |> Repo.insert!()
  end
end

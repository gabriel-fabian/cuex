defmodule Cuex.Conversion.Formalization do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required_attrs [:user_id, :from_currency, :to_currency, :value]

  embedded_schema do
    field :from_currency, :string
    field :to_currency, :string
    field :user_id, :integer
    field :value, :float
  end

  def changeset(conversion \\ %__MODULE__{}, attrs) do
    conversion
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end

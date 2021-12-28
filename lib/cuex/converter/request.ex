defmodule Cuex.Converter.Request do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:user_id, :from_currency, :to_currency, :value, :conversion_rate]

  schema "requests" do
    field :conversion_rate, :float
    field :from_currency, :string
    field :to_currency, :string
    field :user_id, :integer
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
  end
end

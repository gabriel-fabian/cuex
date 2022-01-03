defmodule Cuex.Repo.Migrations.CreateConversionHistories do
  use Ecto.Migration

  def change do
    create table(:conversion_histories) do
      add :user_id, :integer
      add :from_currency, :string
      add :to_currency, :string
      add :value, :float
      add :conversion_rate, :float

      timestamps()
    end
  end
end

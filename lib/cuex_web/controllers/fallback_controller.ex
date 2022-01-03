defmodule CuexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CuexWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CuexWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CuexWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %{status_code: status_code, body: body}}) do
    conn
    |> put_status(status_code)
    |> put_view(CuexWeb.ErrorView)
    |> render("error.json", %{status_code: status_code, body: body})
  end
end

defmodule CuexWeb.RequestController do
  use CuexWeb, :controller

  alias Cuex.Converter
  alias Cuex.Converter.Request

  action_fallback CuexWeb.FallbackController

  def index(conn, _params) do
    requests = Converter.list_requests()
    render(conn, "index.json", requests: requests)
  end

  def show_requests_from_user(conn, %{"user_id" => user_id}) do
    requests = Converter.get_requests_from_user(user_id)
    render(conn, "index.json", requests: requests)
  end
end

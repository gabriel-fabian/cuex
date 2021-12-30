defmodule CuexWeb.RequestController do
  use CuexWeb, :controller

  require Logger

  alias Cuex.Converter

  action_fallback CuexWeb.FallbackController

  def index(conn, _params) do
    Logger.info("RequestController | Received index call")

    requests = Converter.list_requests()
    render(conn, "index.json", requests: requests)
  end

  def show_requests_from_user(conn, %{"user_id" => user_id}) do
    Logger.info("RequestController | Received show_requests_from_user, user_id=#{user_id}")

    requests = Converter.get_requests_from_user(user_id)
    render(conn, "index.json", requests: requests)
  end
end

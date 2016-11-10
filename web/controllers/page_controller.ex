defmodule SpecialType.PageController do
  use SpecialType.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

defmodule Blog.Guardian.ErrorHandler do
  @moduledoc false

  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl true
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, error_message(type))
  end

  defp error_message(message) do
    Jason.encode!(%{
      errors: %{
        message: to_string(message)
      }
    })
  end
end

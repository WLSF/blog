defmodule Blog.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :blog,
    error_handler: Blog.Guardian.ErrorHandler,
    module: Blog.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end

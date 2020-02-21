defmodule BackendWeb.JWT.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :backend,
    module: Backend.JWTSerializer,
    error_handler: BackendWeb.JWT.AuthErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, ensure: true
end

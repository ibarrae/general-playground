port module Ports exposing (manageSession, onSessionChange)

import Json.Encode exposing (Value)

port manageSession : Maybe Value -> Cmd msg

port onSessionChange : (Maybe Value -> msg) -> Sub msg

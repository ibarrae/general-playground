port module Ports exposing (manageToken, onTokenChange)

import Json.Encode exposing (Value)

port manageToken : Maybe Value -> Cmd msg

port onTokenChange : (Maybe Value -> msg) -> Sub msg

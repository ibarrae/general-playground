port module Ports exposing (manageToken, onTokenChange)


port manageToken : Maybe String -> Cmd msg

port onTokenChange : (Maybe String -> msg) -> Sub msg

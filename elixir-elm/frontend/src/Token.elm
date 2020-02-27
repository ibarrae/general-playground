module Token exposing (JWTToken(..), JWTResponse, tokenDecoder)

import Json.Decode as D
import RemoteData exposing (WebData)


type JWTToken = JWTToken String


tokenDecoder : D.Decoder JWTToken
tokenDecoder =
  D.map JWTToken <| D.field "token" D.string


type alias JWTResponse = WebData JWTToken

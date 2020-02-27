module Session exposing (Session(..), JWTToken(..), JWTResponse, tokenDecoder)

import Json.Decode as D
import RemoteData exposing (WebData)
import Browser.Navigation exposing (Key)


type Session = Session
  { apiRoot : String
  , token : Maybe JWTToken
  , navKey : Key
  }

type JWTToken = JWTToken String


tokenDecoder : D.Decoder JWTToken
tokenDecoder =
  D.map JWTToken <| D.field "token" D.string


type alias JWTResponse = WebData JWTToken

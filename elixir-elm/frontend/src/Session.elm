module Session exposing (Session, sessionJson, sessionDecoder, JWTToken(..), JWTResponse, tokenDecoder)

import Json.Decode as D
import RemoteData exposing (WebData)
import Json.Encode exposing (object, Value, string)
import Json.Decode as D exposing (Decoder, field)


type alias Session =
  { apiRoot : String
  , token : JWTToken
  }

sessionJson : String -> JWTToken -> Value
sessionJson apiRoot (JWTToken token) =
  object
    [ ("api_root", string apiRoot)
    , ("token", string token)
    ]

sessionDecoder : Decoder Session
sessionDecoder =
  D.map2 Session (field "api_root" D.string) (D.map JWTToken <| field "token" D.string)

type JWTToken = JWTToken String


tokenDecoder : D.Decoder JWTToken
tokenDecoder =
  D.map JWTToken <| D.field "token" D.string


type alias JWTResponse = WebData JWTToken

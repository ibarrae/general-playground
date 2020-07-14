module Cities exposing (Model, Msg, init, view)


import RemoteData exposing (WebData)
import Array exposing (Array)
import Date exposing (Date)
import Browser exposing (Document)
import Http exposing (request, header, emptyBody)
import Session
import Json.Decode as D exposing (Decoder)
import Json.Decode.Extra as D
import Json.Decode.Pipeline exposing (required, resolve)


type Model = Model
  { session : Session.Session
  , citiesResponse : WebData (Array City)
  }

type City = City
  { name : String
  , founded : Date
  }


dateDecoder : Decoder Date
dateDecoder =
  D.map (D.fromResult << Date.fromIsoString) D.string
    |> resolve


cityDecoder : Decoder City
cityDecoder =
  let
    toDecoder name founded = D.succeed <| City { name = name, founded = founded }
  in
    D.succeed toDecoder
      |> required "name" D.string
      |> required "founded" dateDecoder
      |> resolve

citiesDecoder : Decoder (Array City)
citiesDecoder =
  D.field "cities" <| D.array cityDecoder

type Msg
  = CitiesResponse (WebData (Array City))
  | RefreshCities

getCities : Session.Session -> Cmd Msg
getCities { apiRoot, token } =
  let
    (Session.JWTToken t) = token
  in
    request
      { method = "GET"
      , headers = [ header "Authorization" ("Bearer " ++ t) ]
      , url = apiRoot ++ "/cities"
      , body = emptyBody
      , expect = Http.expectJson (CitiesResponse << RemoteData.fromResult) citiesDecoder
      , timeout = Nothing
      , tracker = Nothing
      }

init : Session.Session -> (Model, Cmd Msg)
init session =
  ( Model
      { session = session
      , citiesResponse =  RemoteData.Loading
      }
  , getCities session
  )


view : Model -> Document Msg
view _ =
  { title = "Cities"
  , body = []
  }

module Cities exposing (Model, Msg, init, view)


import Token exposing (JWTToken)
import RemoteData exposing (WebData)
import Array exposing (Array)
import Date exposing (Date)
import Browser exposing (Document)


type Model = Model
  { token : JWTToken
  }

type City = City
  { name : String
  , founded : Date
  }

type Msg
  = CitiesResponse (WebData (Array City))

init : JWTToken -> (Model, Cmd Msg)
init token = ( Model { token = token }, Cmd.none)


view : Model -> Document Msg
view _ =
  { title = "Cities"
  , body = []
  }

module Cities exposing (Model, Msg, init, view)


import Session exposing (JWTToken)
import RemoteData exposing (WebData)
import Array exposing (Array)
import Date exposing (Date)
import Browser exposing (Document)
import Session


type Model = Model
  { session : Session.Session
  , citiesResponse : WebData (Array City)
  }

type City = City
  { name : String
  , founded : Date
  }

type Msg
  = CitiesResponse (WebData (Array City))
  | RefreshCities

init : Session.Session -> (Model, Cmd Msg)
init session =
  ( Model
      { session = session
      , citiesResponse =  RemoteData.Loading
      }
  , Cmd.none
  )


view : Model -> Document Msg
view _ =
  { title = "Cities"
  , body = []
  }

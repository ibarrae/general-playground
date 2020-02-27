module Cities exposing (Model, Msg, init, view)


import Session exposing (JWTToken)
import RemoteData exposing (WebData)
import Array exposing (Array)
import Date exposing (Date)
import Browser exposing (Document)


type Model = Model
  { token : JWTToken
  , citiesResponse : WebData (Array City)
  }

type City = City
  { name : String
  , founded : Date
  }

type Msg
  = CitiesResponse (WebData (Array City))
  | RefreshCities

init : JWTToken -> (Model, Cmd Msg)
init token =
  ( Model
      { token = token
      , citiesResponse =  RemoteData.Loading
      }
  , Cmd.none
  )


view : Model -> Document Msg
view _ =
  { title = "Cities"
  , body = []
  }

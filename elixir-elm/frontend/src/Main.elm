module Main exposing ( main )

import Html exposing (..)
import Browser


type Msg
  = NoOp


type alias Model =
  { state : List String
  }


initialModel : Model
initialModel = Model []


view : Model -> Html Msg
view model =
  p [] [ text "hi, this was faster than 2 minutes right?!" ]


update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model


main : Program () Model Msg
main =
  Browser.sandbox
    { init = initialModel
    , view = view
    , update = update
    }

module Main exposing ( main )

import Html exposing (..)
import Browser exposing (Document)
import Browser.Navigation as Browser
import Url exposing (Url)


type Msg
  = NoOp
  | UrlChange Url
  | LinkClicked Browser.UrlRequest


type Model = Model
  { state : List String
  }


type alias Config =
  { token : Maybe String
  , apiRoot : String
  }


init : Config -> Url -> Browser.Key -> (Model, Cmd Msg)
init _ _ _ = (Model { state = []}, Cmd.none)


view : Model -> Document Msg
view _ =
  { title = "Elm document"
  , body = [p [] [ text "This was faster than 2 minutes right?!" ]]
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)


main : Program Config Model Msg
main =
  Browser.application
    { init = init
    , onUrlChange = UrlChange
    , onUrlRequest = LinkClicked
    , subscriptions = \_ -> Sub.none
    , update = update
    , view = view
    }

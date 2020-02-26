module Main exposing ( main )

import Html exposing (..)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Url exposing (Url)
import Route exposing (Route)
import Debug


type Msg
  = UrlChange Url
  | LinkClicked UrlRequest


type alias Config =
  { mToken : Maybe String
  , apiRoot : String
  }


type Model
  = NotFound
  | Home
  | Login


init : Config -> Url -> Navigation.Key -> (Model, Cmd Msg)
init ({ mToken, apiRoot } as config) url key = (NotFound, Cmd.none)


view : Model -> Document Msg
view model =
  { title = "Elm document"
  , body = [p [] [ text <| Debug.toString model ]]
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UrlChange url -> changeUrlTo (Route.fromUrl url) model
    LinkClicked (Internal url) -> changeUrlTo (Route.fromUrl url) model
    LinkClicked (External url) -> (model, Navigation.load url)



changeUrlTo : Maybe Route -> Model -> (Model, Cmd Msg)
changeUrlTo mRoute _ =
  case mRoute of
    Nothing -> ( NotFound, Cmd.none )
    Just Route.Home -> ( Home, Cmd.none )
    Just Route.Login -> ( Login, Cmd.none )

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

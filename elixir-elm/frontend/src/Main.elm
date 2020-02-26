module Main exposing ( main )

import Html exposing (..)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Url exposing (Url)
import Route exposing (Route)
import Debug
import Login


type Msg
  = UrlChange Url
  | LinkClicked UrlRequest
  | GotLoginMsg Login.Msg


type alias Config =
  { mToken : Maybe String
  , apiRoot : String
  }


type Model
  = NotFound
  | Home
  | Login Login.Model
  | Movies


init : Config -> Url -> Navigation.Key -> (Model, Cmd Msg)
init ({ mToken, apiRoot } as config) url key =
  case mToken of
    Just token -> (Movies, Cmd.none)
    Nothing    ->
      let (subModel, subCmd) = Login.init apiRoot
      in  (Login subModel, Cmd.map GotLoginMsg subCmd)


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


view : Model -> Document Msg
view model =
  let body =
        case model of
          NotFound -> [p [] [text "The page you are looking for is not found"]]
          Home -> [div [] []]
          Login loginModel -> [p [] [ text "Login"] ]
          Movies -> [div [] [] ]
  in
      { title = "Elm document"
      , body = body
      }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model) of
    (UrlChange url, _) -> changeUrlTo (Route.fromUrl url) model
    (LinkClicked (Internal url), _) -> changeUrlTo (Route.fromUrl url) model
    (LinkClicked (External url), _) -> (model, Navigation.load url)
    (GotLoginMsg loginMsg, Login loginModel) ->
      Login.update loginMsg loginModel
        |> updateWith Login GotLoginMsg model
    _ -> (model, Cmd.none)


changeUrlTo : Maybe Route -> Model -> (Model, Cmd Msg)
changeUrlTo mRoute model =
  case (mRoute, model) of
    (Just Route.Login, Login loginModel) -> ( Login loginModel, Cmd.none )
    (Just Route.Home, _) -> ( Home, Cmd.none )
    (_, _) -> ( NotFound, Cmd.none )


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

module Main exposing ( main )

import Html exposing (text, p)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Url exposing (Url)
import Route exposing (Route)
import Login
import List
import Cities
import Token
import Ports


type Msg
  = UrlChange Url
  | LinkClicked UrlRequest
  | TokenChanged (Maybe String)
  | GotLoginMsg Login.Msg
  | GotCitiesMsg Cities.Msg


type alias Config =
  { mToken : Maybe String
  , apiRoot : String
  }


type Model
  = NotFound
  | Home
  | Login Login.Model
  | Cities Cities.Model


init : Config -> Url -> Navigation.Key -> (Model, Cmd Msg)
init ({ mToken, apiRoot }) _ _ =
  case mToken of
    Just token ->
      Cities.init (Token.JWTToken token)
        |> updateWith Cities GotCitiesMsg

    Nothing    ->
      Login.init apiRoot
        |> updateWith Login GotLoginMsg


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


updateViewWith : Document subMsg -> (subMsg -> Msg) -> Document Msg
updateViewWith {title, body} toMsg =
  {title = title, body = List.map (Html.map toMsg) body}


view : Model -> Document Msg
view model =
  case model of
    NotFound ->
      { title = "Not found"
      , body = [ p [] [ text "The page you are looking for is not found" ] ]
      }
    Home -> { title = "Home", body = [] }
    Login loginModel -> updateViewWith (Login.view loginModel) GotLoginMsg
    Cities citiesModel -> updateViewWith (Cities.view citiesModel) GotCitiesMsg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model) of
    (UrlChange url, _) -> changeUrlTo (Route.fromUrl url) model
    (LinkClicked (Internal url), _) -> changeUrlTo (Route.fromUrl url) model
    (LinkClicked (External url), _) -> (model, Navigation.load url)
    (TokenChanged (Just token), _) ->
      Cities.init (Token.JWTToken token)
        |> updateWith Cities GotCitiesMsg
    (TokenChanged Nothing, _) -> (model, Cmd.none)
    (GotLoginMsg loginMsg, Login loginModel) ->
      Login.update loginMsg loginModel
        |> updateWith Login GotLoginMsg
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
    , subscriptions = subscriptions
    , update = update
    , view = view
    }

subscriptions : Model -> Sub Msg
subscriptions _ = Ports.onTokenChange TokenChanged

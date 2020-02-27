module Login exposing (Model, Msg, init, update, view)

import Html exposing (div, label, input, form, text, button)
import Html.Attributes as Html exposing (class, for, id, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Browser exposing (Document)
import RemoteData
import Http exposing (request, emptyBody)
import Base64
import Session exposing (JWTToken(..), sessionJson, JWTResponse, tokenDecoder)
import Ports

type UserInput = UserInput
  { uiEmail : String
  , uiPassword : String
  }

updateEmail : UserInput -> String -> UserInput
updateEmail (UserInput input) email =
  UserInput { input | uiEmail = email }

updatePassword : UserInput -> String -> UserInput
updatePassword (UserInput input) password =
  UserInput { input | uiPassword = password }

getEmail : UserInput -> String
getEmail (UserInput {uiEmail}) =
  uiEmail

getPassword : UserInput -> String
getPassword (UserInput {uiPassword}) =
  uiPassword


type Model = Model
  { apiRoot : String
  , userInput : UserInput
  , loginResponse : JWTResponse
  }

type Msg
  = EmailChange String
  | PasswordChange String
  | SubmitUserInfo
  | LoginResponse JWTResponse

init : String -> (Model, Cmd msg)
init root =
  ( Model
    { apiRoot = root
    , userInput = UserInput { uiEmail = "", uiPassword = "" }
    , loginResponse = RemoteData.NotAsked
    }
  , Cmd.none
  )


basicAuthHeader : String -> String -> Http.Header
basicAuthHeader email pwd =
  Http.header "Authorization" <| "Basic " ++ Base64.encode (email ++ ":" ++ pwd)


loginWithBasicAuth : String -> UserInput -> Cmd Msg
loginWithBasicAuth apiRoot (UserInput {uiEmail, uiPassword}) =
  request
    { method = "POST"
    , headers = [ basicAuthHeader uiEmail uiPassword ]
    , url = apiRoot ++ "/users/sign-in"
    , body = emptyBody
    , expect = Http.expectJson (LoginResponse << RemoteData.fromResult) tokenDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


update : Msg -> Model -> (Model, Cmd Msg)
update msg (Model ({apiRoot, userInput} as model)) =
  case msg of
    EmailChange email ->
      ( Model { model | userInput = updateEmail userInput email }
      , Cmd.none
      )

    PasswordChange password ->
      ( Model { model | userInput = updatePassword userInput password }
      , Cmd.none
      )

    SubmitUserInfo ->
      ( Model { model | loginResponse = RemoteData.Loading }
      , loginWithBasicAuth apiRoot userInput
      )

    LoginResponse response ->
      ( Model { model | loginResponse = response }
      , case response of
          RemoteData.Success token ->
            Ports.manageSession <| Just <| sessionJson apiRoot  token
          _ -> Cmd.none
      )

view : Model -> Document Msg
view (Model ({userInput, loginResponse})) =

  let (disabledClass, loadingText, disabled) =
        case loginResponse of
          RemoteData.Loading -> ("btn-disabled", " loading ...", True)
          _ -> ("", "", False)
  in
    { title = "Login"
    , body = [
        div
        [ class "container" ]
        [ form
          [ onSubmit SubmitUserInfo ]
          [ div
              [ class "form-group"]
              [ label [ for "email" ] [text "Email:"]
              , input [class "form-control", id "email", type_ "email", value <| getEmail userInput, onInput EmailChange] []
              ]
          , div
              [ class "form-group"]
              [ label [ for "password" ] [ text "Password:" ]
              , input [class "form-control", id "password", type_ "password", value <| getPassword userInput, onInput PasswordChange] []
              ]
          , button [ class <| "btn btn-primary" ++ disabledClass, Html.disabled disabled ] [text <| "Login" ++ loadingText]
          ]

        ]
      ]
    }

module Login exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, label, input, form, text, button)
import Html.Attributes exposing (class, for, id, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Browser exposing (Document)
import RemoteData exposing (WebData)
import Http exposing (post, emptyBody, expectWhatever)

type UserInput = UserInput
  { uiEmail : String
  , uiPassword : String
  }

updateEmail : UserInput -> String -> UserInput
updateEmail (UserInput input) email =
  UserInput ({ input | uiEmail = email })

updatePassword : UserInput -> String -> UserInput
updatePassword (UserInput input) password =
  UserInput ({ input | uiPassword = password })

getEmail : UserInput -> String
getEmail (UserInput {uiEmail, uiPassword}) =
  uiEmail

getPassword : UserInput -> String
getPassword (UserInput {uiEmail, uiPassword}) =
  uiPassword

type Model = Model
  { apiRoot : String
  , userInput : UserInput
  , loginResponse : WebData ()
  }

type Msg
  = EmailChange String
  | PasswordChange String
  | SubmitUserInfo
  | LoginResponse (WebData ())

init : String -> (Model, Cmd msg)
init root =
  ( Model
    { apiRoot = root
    , userInput = UserInput { uiEmail = "", uiPassword = ""}
    , loginResponse = RemoteData.NotAsked
    }
  , Cmd.none
  )

loginWithBasicAuth : String -> UserInput -> Cmd Msg
loginWithBasicAuth apiRoot (UserInput {uiEmail, uiPassword}) =
  post
    { url = apiRoot ++ "/users/sign-in"
    , body = emptyBody
    , expect = expectWhatever (RemoteData.fromResult >> LoginResponse) }

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
    SubmitUserInfo -> ( Model model, loginWithBasicAuth apiRoot userInput )
    LoginResponse response -> ( Model ({ model | loginResponse = response}), Cmd.none )

view : Model -> Document Msg
view (Model ({apiRoot, userInput, loginResponse})) =

  let (disabledClass, loadingText) =
        case loginResponse of
          RemoteData.Loading -> ("btn-disabled", " loading ...")
          _ -> ("", "")
  in
    { title = "Login"
    , body = [
        div
        [ class "container" ]
        [ form
          [ onSubmit SubmitUserInfo ]
          [ div
              [ class "form-group"]
              [ label [ for "email"] [text "Email:"]
              , input [class "form-control", id "email", type_ "email", value <| getEmail userInput, onInput EmailChange] []
              ]
          , div
              [ class "form-group"]
              [ label [ for "password"] [text "Password:"]
              , input [class "form-control", id "password", type_ "password", value <| getPassword userInput, onInput PasswordChange] []
              ]
          , button [ class <| "btn btn-primary" ++ disabledClass ] [text <| "Login" ++ loadingText]
          ]

        ]
      ]
    }

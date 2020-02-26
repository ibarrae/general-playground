module Login exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, label, input, form, text, button)
import Html.Attributes exposing (class, for, id, type_, value)
import Html.Events exposing (onInput)
import Browser exposing (Document)
import Debug

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
  }

type Msg
  = OnEmailChange String
  | OnPasswordChange String
  | OnSubmit

init : String -> (Model, Cmd msg)
init root =
  ( Model
    { apiRoot = root
    , userInput = UserInput { uiEmail = "", uiPassword = ""}
    }
  , Cmd.none
  )

update : Msg -> Model -> (Model, Cmd msg)
update msg (Model ({apiRoot, userInput} as model)) =
  case msg of
    OnEmailChange email ->
      ( Model { model | userInput = updateEmail userInput email }
      , Cmd.none
      )

    OnPasswordChange password ->
      ( Model { model | userInput = updatePassword userInput password }
      , Cmd.none
      )
    OnSubmit -> ( Model model, Cmd.none )

view : Model -> Document Msg
view (Model ({apiRoot, userInput})) =
  { title = "Login"
  , body = [
      div
      [ class "container" ]
      [ form
        []
        [ div
            [ class "form-group"]
            [ label [ for "email"] [text "Email:"]
            , input [class "form-control", id "email", type_ "email", value <| getEmail userInput, onInput OnEmailChange] []
            ]
        , div
            [ class "form-group"]
            [ label [ for "password"] [text "Password:"]
            , input [class "form-control", id "password", type_ "password", value <| getPassword userInput, onInput OnPasswordChange] []
            ]
        , button [ class "btn btn-primary" ] [text "Login"]
        ]

      ]
    ]
  }

module Login exposing (Model, Msg, init, update)

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

type Model = Model
  { apiRoot : String
  , userInput : UserInput
  }

type Msg
  = OnEmailChange String
  | OnPasswordChange String
  | OnSubmit

init : String -> (Model, Cmd Msg)
init root =
  ( Model
    { apiRoot = root
    , userInput = UserInput { uiEmail = "", uiPassword = ""}
    }
  , Cmd.none
  )

update : Msg -> Model -> (Model, Cmd Msg)
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

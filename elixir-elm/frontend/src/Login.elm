module Login exposing (Model, Msg, init)

type UserInput = UserInput
  { uiEmail : String
  , uiPassword : String
  }

type Model = Model
  { apiRoot : String
  , userInput : UserInput
  }

type Msg
  = OnEmailChange String
  | OnPasswordChange String
  | Submit

init : String -> (Model, Cmd Msg)
init root =
  ( Model
    { apiRoot = root
    , userInput = UserInput { uiEmail = "", uiPassword = ""}
    }
  , Cmd.none
  )

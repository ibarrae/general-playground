module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s, top, parse)

type Route
  = Home
  | Login
  | Cities

parser : Parser (Route -> a) a
parser =
  oneOf
    [ Parser.map Home top
    , Parser.map Login (s "login")
    , Parser.map Cities (s "cities")
    ]

fromUrl : Url -> Maybe Route
fromUrl url = parse parser url

module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string, top, parse)
import Debug

type Route
  = Home
  | Login

parser : Parser (Route -> a) a
parser =
  oneOf
    [ Parser.map Home top
    , Parser.map Login (s "login")
    ]

fromUrl : Url -> Maybe Route
fromUrl url = parse parser url

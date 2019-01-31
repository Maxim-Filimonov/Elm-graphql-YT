module Main exposing (..)

import Html exposing(text)

view = text "Hello"

type lias 
update: Msg -> Model -> Model
update msg model = model

main = Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

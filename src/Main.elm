module Main exposing (Msg, main, update, view)

import Browser
import Html exposing (text)


view =
    text "Hello"


type alias Msg =
    Int


type alias Model =
    {}


update : Msg -> Model -> Model
update msg model =
    model


init =
    ( {}, Cmd.none )


view : Model -> Html prog


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

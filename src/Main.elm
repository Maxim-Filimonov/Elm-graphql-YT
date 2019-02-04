module Main exposing (Msg, main, update, view)

import Browser
import Html exposing (text)


view : OurModel -> Html.Html Msg
view model =
    text "Hello"


type alias Msg =
    Int


type alias OurModel =
    {}


update : Msg -> OurModel -> ( OurModel, Cmd Msg )
update msg model =
    ( model, Cmd.none )


type alias Flags =
    {}


init : Flags -> ( OurModel, Cmd Msg )
init flags =
    ( {}, Cmd.none )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

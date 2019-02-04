module Main exposing (Msg, main, update, view)

import Browser
import Graphql.Document as Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet, with)
import Html exposing (div, text)
import Swapi.Object
import Swapi.Object.Human as HumanGql
import Swapi.Query as Query
import Swapi.Scalar exposing (Id(..))


view : OurModel -> Html.Html Msg
view model =
    div []
        [ text (Document.serializeQuery query)
        ]


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



-- Graphql JAZZ


query : SelectionSet (Maybe Human) RootQuery
query =
    Query.human { id = Id "1001" } humanSelection



-- query requires datatype from the library


humanSelection : SelectionSet Human Swapi.Object.Human
humanSelection =
    Graphql.SelectionSet.map2 Human
        HumanGql.name
        HumanGql.homePlanet


type alias Human =
    { name : String
    , homePlanet : Maybe String
    }



-- rest of elm


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

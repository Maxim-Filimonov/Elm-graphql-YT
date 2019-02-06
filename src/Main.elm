module Main exposing (Msg, main, update, view)

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet, with)
import Html exposing (div, text)
import RemoteData
import Swapi.Object
import Swapi.Object.Human as HumanGql
import Swapi.Query as Query
import Swapi.Scalar exposing (Id(..))


view : OurModel -> Html.Html Msg
view model =
    case model.queryResult of
        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success response ->
            case response of
                Just human ->
                    text (human.name ++ " from " ++ Maybe.withDefault "nowhere" human.homePlanet)

                Nothing ->
                    text "got nothing"

        RemoteData.Failure _ ->
            text "faled"

        RemoteData.NotAsked ->
            text "waiting for something"


type alias OurModel =
    { queryResult : RemoteModel
    }


update : Msg -> OurModel -> ( OurModel, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( { model | queryResult = response }, Cmd.none )


type alias Flags =
    {}


init : Flags -> ( OurModel, Cmd Msg )
init flags =
    ( { queryResult = RemoteData.Loading }, makeRequest )



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


type alias Response =
    Maybe Human


type alias RemoteModel =
    RemoteData.RemoteData (Graphql.Http.Error Response) Response


type Msg
    = GotResponse RemoteModel


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest
            "https://graphqelm.herokuapp.com/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)



-- rest of elm


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

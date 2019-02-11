module Main exposing (Msg, main, update, view)

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet exposing (SelectionSet, with)
import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import RemoteData
import Swapi.Mutation as Mutation
import Swapi.Object
import Swapi.Object.Human as HumanGql
import Swapi.Query as Query
import Swapi.Scalar exposing (Id(..))


renderQueryResult queryResult =
    case queryResult of
        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success response ->
            case response of
                Just human ->
                    text <|
                        renderHuman human

                Nothing ->
                    text "got nothing"

        RemoteData.Failure error ->
            text "failed with error"

        RemoteData.NotAsked ->
            text "waiting for something"


view : OurModel -> Html.Html Msg
view model =
    div []
        [ renderQueryResult model.queryResult
        , button [ onClick Increment ] [ text "Click me" ]
        , renderMutationResult model.mutationResult
        ]


renderMutationResult : RemoteUpdateModel -> Html.Html Msg
renderMutationResult response =
    case response of
        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success result ->
            text ("Increment result is " ++ String.fromInt result)

        RemoteData.Failure error ->
            text "failed with error"

        RemoteData.NotAsked ->
            text "waiting for something"


type alias OurModel =
    { queryResult : RemoteModel
    , mutationResult : RemoteUpdateModel
    }


update : Msg -> OurModel -> ( OurModel, Cmd Msg )
update msg model =
    case msg of
        GotQueryResult response ->
            ( { model | queryResult = response }, Cmd.none )

        GotMutationResult response ->
            ( { model | mutationResult = response }, Cmd.none )

        Increment ->
            ( { model | mutationResult = RemoteData.Loading }, makeUpdateRequest )


type alias Flags =
    {}


init : Flags -> ( OurModel, Cmd Msg )
init flags =
    ( { queryResult = RemoteData.NotAsked, mutationResult = RemoteData.NotAsked }, makeRequest )



-- Graphql JAZZ


query : SelectionSet (Maybe Human) RootQuery
query =
    -- play with this id to see different results
    Query.human { id = Id "1002" } humanSelection


type alias MutationResponse =
    Int


mutation : SelectionSet MutationResponse RootMutation
mutation =
    Mutation.increment


makeUpdateRequest : Cmd Msg
makeUpdateRequest =
    mutation
        |> Graphql.Http.mutationRequest "https://elm-graphql.herokuapp.com"
        |> Graphql.Http.send (RemoteData.fromResult >> GotMutationResult)



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


renderHuman : Human -> String
renderHuman human =
    let
        name =
            human.name
    in
    case human.homePlanet of
        Just homePlanet ->
            name
                ++ " from "
                ++ homePlanet

        Nothing ->
            name


type alias Response =
    Maybe Human


type alias RemoteModel =
    RemoteData.RemoteData (Graphql.Http.Error Response) Response


type alias RemoteUpdateModel =
    RemoteData.RemoteData (Graphql.Http.Error MutationResponse) MutationResponse


type Msg
    = GotQueryResult RemoteModel
    | GotMutationResult RemoteUpdateModel
    | Increment


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest
            "https://graphqelm.herokuapp.com/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotQueryResult)



-- rest of elm


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

module Graphql exposing
    ( Document, Fragment, Error(..)
    , document, fragment
    , fragmentName
    , serializeDocument
    , request
    )

{-| Helper functions for working with Graphql


# Types

@docs Document, Fragment, Error


# Constructors

@docs document, fragment


# Info

@docs fragmentName


# Transform

@docs serializeDocument


# Http

@docs request

-}

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Regex
import Set
import Task exposing (Task)
import Url.Builder



-- TYPES


type Document
    = Document String (List String)


type Fragment
    = Fragment String (List Fragment)



-- CONSTRUCTORS


fragment : String -> List Fragment -> Fragment
fragment body referencedFragments =
    Fragment body referencedFragments


document : String -> List Fragment -> Document
document operation fragments =
    Document operation (flatten fragments)



-- INFO


fragmentName : Fragment -> String
fragmentName (Fragment body _) =
    let
        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString "fragment ([A-Za-z]+)"

        matches =
            Regex.findAtMost 1 regex body
    in
    case matches of
        { submatches } :: _ ->
            case submatches of
                (Just name) :: _ ->
                    name

                _ ->
                    "Unknown"

        _ ->
            "Unknown"



-- TRANSFORM


serializeDocument : Document -> String
serializeDocument (Document body fragments) =
    (body :: fragments)
        |> List.map normalize
        |> String.join "\n"



-- HTTP


type Error
    = Error
    | Unauthorized


requestedWithHeader : Http.Header
requestedWithHeader =
    Http.header "X-Requested-With" "XMLHttpRequest"


request : Document -> List Http.Header -> Maybe Value -> Decoder a -> Task Error a
request doc headers maybeVariables decoder =
    Http.task
        { method = "POST"
        , headers = [] ++ headers
        , url = Url.Builder.absolute [ "api", "graphql" ] []

        -- , url = "http://localhost:4000/api/graphql"
        , body = httpBody doc maybeVariables
        , resolver = jsonResolver decoder
        , timeout = Nothing
        }


jsonResolver : Decoder a -> Http.Resolver Error a
jsonResolver decoder =
    Http.stringResolver <|
        \response ->
            case response of
                Http.GoodStatus_ _ body ->
                    Decode.decodeString (responseDecoder decoder) body
                        |> Result.mapError
                            (\err ->
                                case err of
                                    Decode.Failure "unauthorized" _ ->
                                        Unauthorized

                                    _ ->
                                        Error
                            )

                _ ->
                    Err Error


responseDecoder : Decode.Decoder a -> Decode.Decoder a
responseDecoder dataDecoder =
    Decode.succeed
        (\message ->
            if message == "unauthorized" then
                Decode.fail "unauthorized"

            else
                Decode.succeed ()
        )
        |> Decode.optionalAt [ "errors", "0", "message" ] Decode.string ""
        |> Decode.resolve
        |> Decode.andThen (\_ -> dataDecoder)


httpBody : Document -> Maybe Value -> Http.Body
httpBody doc maybeVariables =
    let
        query =
            serializeDocument doc
    in
    Http.jsonBody <|
        case maybeVariables of
            Nothing ->
                Encode.object
                    [ ( "query", Encode.string query ) ]

            Just variables ->
                Encode.object
                    [ ( "query", Encode.string query )
                    , ( "variables", variables )
                    ]



-- INTERNAL


uniq : List comparable -> List comparable
uniq list =
    list
        |> Set.fromList
        |> Set.toList


flatten : List Fragment -> List String
flatten fragments =
    let
        toList : Fragment -> List String
        toList f =
            case f of
                Fragment body [] ->
                    [ body ]

                Fragment body referencedFragments ->
                    referencedFragments
                        |> List.map toList
                        |> List.concat
                        |> (::) body
    in
    fragments
        |> List.map toList
        |> List.concat
        |> uniq


normalize : String -> String
normalize value =
    let
        lines =
            value
                |> String.lines

        firstLine =
            lines
                |> List.head
                |> Maybe.withDefault ""

        tailPadding =
            lines
                |> List.tail
                |> Maybe.withDefault []
                |> List.map String.toList
                |> List.map (countPadding 0)
                |> List.minimum
                |> Maybe.withDefault 0
    in
    lines
        |> List.tail
        |> Maybe.withDefault []
        |> List.map (String.dropLeft tailPadding)
        |> (::) firstLine
        |> String.join "\n"


countPadding : Int -> List Char -> Int
countPadding count list =
    case list of
        [ ' ' ] ->
            count + 1

        ' ' :: tl ->
            countPadding (count + 1) tl

        _ ->
            count

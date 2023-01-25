module Data.Log exposing
    ( Log
    , LogGroup
    , amount
    , category
    , decoder
    , fragment
    , id
    , loggedAt
    , memo
    , toLogGroups
    , user
    )

import Data.Category as Category exposing (Category)
import Data.LogId as LogId exposing (LogId)
import Data.Money as Money exposing (Money)
import Data.User as User exposing (User)
import Graphql
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Time



-- TYPES


type Log
    = Log Internal


type alias Internal =
    { id : LogId
    , memo : Maybe String
    , amount : Money Money.Usd
    , loggedAt : Time.Posix
    , user : User
    , category : Category
    , groupName : String
    , groupSpentAmount : Money Money.Usd
    }



-- PROPERTIES


id : Log -> LogId
id (Log log) =
    log.id


loggedAt : Log -> Time.Posix
loggedAt (Log log) =
    log.loggedAt


user : Log -> User
user (Log log) =
    log.user


memo : Log -> Maybe String
memo (Log log) =
    log.memo


category : Log -> Category
category (Log log) =
    log.category


amount : Log -> Money Money.Usd
amount (Log log) =
    log.amount



-- SERIALIZATION


decoder : Decode.Decoder Log
decoder =
    Decode.succeed Internal
        |> Decode.required "id" LogId.decoder
        |> Decode.required "memo" (Decode.nullable Decode.string)
        |> Decode.required "amount" Money.usdDecoder
        |> Decode.required "loggedAt" Iso8601.decoder
        |> Decode.required "user" User.decoder
        |> Decode.required "category" Category.decoder
        |> Decode.required "groupName" Decode.string
        |> Decode.required "groupSpentAmount" Money.usdDecoder
        |> Decode.map Log


fragment : Graphql.Fragment
fragment =
    Graphql.fragment
        """
        fragment LogFields on Log {
          id
          memo
          amount {
            ...MoneyFields
          }
          loggedAt
          user {
            ...UserFields
          }
          category {
            ...CategoryFields
          }
          groupName
          groupSpentAmount{
            ...MoneyFields
          }
        }
        """
        [ Money.fragment
        , User.fragment
        , Category.fragment
        ]



-- MOCK


toLogGroups : List Log -> List LogGroup
toLogGroups logs =
    let
        toLogGroup l list =
            { name = l.groupName
            , spent = l.groupSpentAmount
            , logs = list
            }
    in
    logs
        |> List.foldl
            (\(Log log) ( curKey, curLogGroup, groups ) ->
                if curKey == "" then
                    ( log.groupName, toLogGroup log [ Log log ], [] )

                else if log.groupName == curKey then
                    ( curKey, { curLogGroup | logs = List.append curLogGroup.logs [ Log log ] }, groups )

                else
                    ( log.groupName, toLogGroup log [ Log log ], List.append groups [ curLogGroup ] )
            )
            ( "", { name = "", spent = Money.fromInt 0, logs = [] }, [] )
        |> (\( _, curLogGroup, groups ) ->
                List.append groups [ curLogGroup ]
           )


type alias LogGroup =
    { name : String
    , spent : Money Money.Usd
    , logs : List Log
    }

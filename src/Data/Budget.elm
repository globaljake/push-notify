module Data.Budget exposing
    ( Budget
    , Frequency(..)
    , activePeriod
    , allowanceAmount
    , creator
    , decoder
    , decoderFrequency
    , encodeFrequency
    , fragment
    , frequency
    , frequencyFromString
    , frequencyToString
    , id
    , name
    , spentAmount
    )

import Data.BudgetId as BudgetId exposing (BudgetId)
import Data.Money as Money exposing (Money)
import Data.User as User exposing (User)
import Graphql
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode



-- TYPES


type Budget
    = Budget Internal


type alias Internal =
    { id : BudgetId
    , name : String
    , allowanceAmount : Money Money.Usd
    , spentAmount : Money Money.Usd
    , creator : User
    , frequency : Frequency
    , activePeriod : String
    }


type Frequency
    = Monthly
    | Weekly
    | Daily



-- PROPERTIES


id : Budget -> BudgetId
id (Budget budget) =
    budget.id


name : Budget -> String
name (Budget budget) =
    budget.name


allowanceAmount : Budget -> Money Money.Usd
allowanceAmount (Budget budget) =
    budget.allowanceAmount


spentAmount : Budget -> Money Money.Usd
spentAmount (Budget budget) =
    budget.spentAmount


creator : Budget -> User
creator (Budget budget) =
    budget.creator


frequency : Budget -> Frequency
frequency (Budget budget) =
    budget.frequency


activePeriod : Budget -> String
activePeriod (Budget budget) =
    budget.activePeriod



-- SERIALIZATION


decoder : Decode.Decoder Budget
decoder =
    Decode.succeed Internal
        |> Decode.required "id" BudgetId.decoder
        |> Decode.required "name" Decode.string
        |> Decode.required "allowanceAmount" Money.usdDecoder
        |> Decode.required "spentAmount" Money.usdDecoder
        |> Decode.required "creator" User.decoder
        |> Decode.optional "frequency" decoderFrequency Monthly
        |> Decode.required "activePeriod" Decode.string
        |> Decode.map Budget


frequencyFromString : String -> Frequency
frequencyFromString freqString =
    case freqString of
        "MONTHLY" ->
            Monthly

        "WEEKLY" ->
            Weekly

        "DAILY" ->
            Daily

        _ ->
            Monthly


frequencyToString : Frequency -> String
frequencyToString frequency_ =
    case frequency_ of
        Monthly ->
            "MONTHLY"

        Weekly ->
            "WEEKLY"

        Daily ->
            "DAILY"


decoderFrequency : Decode.Decoder Frequency
decoderFrequency =
    Decode.map frequencyFromString Decode.string


encodeFrequency : Frequency -> Encode.Value
encodeFrequency frequency_ =
    Encode.string (frequencyToString frequency_)


fragment : Graphql.Fragment
fragment =
    Graphql.fragment
        """
        fragment BudgetFields on Budget {
            id
            name
            allowanceAmount {
                ...MoneyFields
            }
            spentAmount {
                ...MoneyFields
            }
            creator {
                ...UserFields
            }
            frequency
            activePeriod
        }
        """
        [ Money.fragment
        , User.fragment
        ]

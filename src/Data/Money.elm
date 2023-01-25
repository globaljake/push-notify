module Data.Money exposing
    ( Money
    , Usd
    , add
    , clamp
    , compare
    , div
    , encodeUsd
    , eq
    , fragment
    , fromDollars
    , fromInt
    , isZero
    , maxDonationUsd
    , min
    , multi
    , sub
    , sum
    , toCents
    , toDollars
    , toString
    , toStringUsd
    , toTruncatedStringUsd
    , usdDecoder
    , zero
    )

import Graphql
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode
import String.Extra as String



-- TYPES


type Money a
    = Money Int


type Usd
    = Usd



-- MATH


compare : Money a -> Money a -> Order
compare (Money x) (Money y) =
    Basics.compare x y


eq : Money a -> Money a -> Bool
eq (Money x) (Money y) =
    x == y


min : Money a -> Money a -> Money a
min (Money x) (Money y) =
    Money (Basics.min x y)


add : Money a -> Money a -> Money a
add (Money x) (Money y) =
    Money (x + y)


sub : Money a -> Money a -> Money a
sub (Money y) (Money x) =
    Money (x - y)


div : Float -> Money a -> Money a
div y (Money x) =
    Money (round <| toFloat x / y)


multi : Float -> Money a -> Money a
multi y (Money x) =
    Money (round <| toFloat x * y)


clamp : Money a -> Money a -> Money a -> Money a
clamp (Money x) (Money y) (Money z) =
    Money <| Basics.clamp x y z


isZero : Money a -> Bool
isZero =
    eq zero


zero : Money a
zero =
    Money 0


sum : List (Money a) -> Money a
sum =
    List.foldl add zero



-- INFO


maxDonationUsd : Money Usd
maxDonationUsd =
    Money 1000000



-- TRANSFORM


fromInt : Int -> Money a
fromInt int =
    Money int


toDollars : Money a -> Int
toDollars (Money money) =
    money // 100


toCents : Money a -> Int
toCents (Money money) =
    money


fromDollars : Int -> Money a
fromDollars value =
    Money (value * 100)


toString : Money a -> String
toString (Money money) =
    String.fromInt <| money // 100


toStringUsd : Money Usd -> String
toStringUsd (Money money) =
    String.concat
        [ toTruncatedStringUsd (Money money)
        , "."
        , money
            |> abs
            |> remainderBy 100
            |> String.fromInt
            |> String.padLeft 2 '0'
        ]


toTruncatedStringUsd : Money Usd -> String
toTruncatedStringUsd (Money money) =
    if money > 0 then
        (money // 100)
            |> String.fromIntWithDelimiter ","
            |> String.append "$"

    else
        (money // 100)
            |> abs
            |> String.fromIntWithDelimiter ","
            |> String.append "-$"



-- SERIALIZATION


usdDecoder : Decode.Decoder (Money Usd)
usdDecoder =
    Decode.field "currency" Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "USD" ->
                        Decode.field "valueInCents" Decode.int
                            |> Decode.map Money

                    _ ->
                        Decode.fail ""
            )


encodeUsd : Money Usd -> Encode.Value
encodeUsd (Money money) =
    Encode.object
        [ ( "valueInCents", Encode.int money )
        , ( "currency", Encode.string "USD" )
        ]


fragment : Graphql.Fragment
fragment =
    Graphql.fragment
        """
        fragment MoneyFields on Money {
          currency
          valueInCents
        }
        """
        []

module Data.Category exposing
    ( Category
    , allowanceAmount
    , decoder
    , fragment
    , id
    , key
    , monthlyAllowanceAmount
    , name
    , spentAmount
    )

import Data.CategoryId as CategoryId exposing (CategoryId)
import Data.Money as Money exposing (Money)
import Graphql
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode



-- TYPES


type Category
    = Category Internal


type alias Internal =
    { id : CategoryId
    , name : String
    , monthlyAllowanceAmount : Money Money.Usd
    , allowanceAmount : Money Money.Usd
    , spentAmount : Money Money.Usd
    }



--PROPERTIES


id : Category -> CategoryId
id (Category category) =
    category.id


key : Category -> String
key (Category category) =
    CategoryId.key category.id


name : Category -> String
name (Category category) =
    category.name


monthlyAllowanceAmount : Category -> Money Money.Usd
monthlyAllowanceAmount (Category category) =
    category.monthlyAllowanceAmount


allowanceAmount : Category -> Money Money.Usd
allowanceAmount (Category category) =
    category.allowanceAmount


spentAmount : Category -> Money Money.Usd
spentAmount (Category category) =
    category.spentAmount



-- SERIALIZATION


decoder : Decode.Decoder Category
decoder =
    Decode.succeed Internal
        |> Decode.required "id" CategoryId.decoder
        |> Decode.required "name" Decode.string
        |> Decode.required "monthlyAllowanceAmount" Money.usdDecoder
        |> Decode.required "allowanceAmount" Money.usdDecoder
        |> Decode.required "spentAmount" Money.usdDecoder
        |> Decode.map Category


fragment : Graphql.Fragment
fragment =
    Graphql.fragment
        """
        fragment CategoryFields on Category {
            id
            name
            monthlyAllowanceAmount {
                ...MoneyFields
            }
            allowanceAmount {
                ...MoneyFields
            }
            spentAmount {
                ...MoneyFields
            }
        }
        """
        [ Money.fragment
        ]

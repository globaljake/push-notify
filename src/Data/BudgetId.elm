module Data.BudgetId exposing (BudgetId, decoder, encode)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Json.Encode as Encode


type BudgetId
    = BudgetId String


decoder : Decode.Decoder BudgetId
decoder =
    Decode.map BudgetId Decode.uuidString


encode : BudgetId -> Encode.Value
encode (BudgetId budgetId) =
    Encode.string budgetId

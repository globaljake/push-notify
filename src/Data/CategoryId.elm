module Data.CategoryId exposing (CategoryId, decoder, encode, key)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Json.Encode as Encode


type CategoryId
    = CategoryId String


key : CategoryId -> String
key (CategoryId id) =
    "categoy-" ++ id


decoder : Decode.Decoder CategoryId
decoder =
    Decode.map CategoryId Decode.uuidString


encode : CategoryId -> Encode.Value
encode (CategoryId categoryId) =
    Encode.string categoryId

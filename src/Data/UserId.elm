module Data.UserId exposing (UserId, decoder, encode)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Json.Encode as Encode


type UserId
    = UserId String


decoder : Decode.Decoder UserId
decoder =
    Decode.map UserId Decode.uuidString


encode : UserId -> Encode.Value
encode (UserId userId) =
    Encode.string userId

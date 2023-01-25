module Data.LogId exposing (LogId, decoder, encode)

import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Json.Encode as Encode


type LogId
    = LogId String


decoder : Decode.Decoder LogId
decoder =
    Decode.map LogId Decode.uuidString


encode : LogId -> Encode.Value
encode (LogId logId) =
    Encode.string logId

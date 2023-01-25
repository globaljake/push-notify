module Flags exposing (Flags, fromValue)

import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode



-- TYPE


type alias Flags =
    {}



-- VALUES


default : Flags
default =
    {}



-- ADAPTERS


fromValue : Encode.Value -> Flags
fromValue value =
    Decode.decodeValue decoder value
        |> Result.withDefault default


decoder : Decode.Decoder Flags
decoder =
    -- let
    --     stringDecoder : Decode.Decoder a -> a -> Decode.Decoder a
    --     stringDecoder dec def =
    --         Decode.string
    --             |> Decode.map
    --                 (\s ->
    --                     Decode.decodeString dec s
    --                         |> Result.withDefault def
    --                 )
    -- in
    Decode.succeed Flags

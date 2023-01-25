module Json.Encode.Extra exposing (maybe)

import Json.Encode as Encode


maybe : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybe f entry =
    case entry of
        Just x ->
            f x

        Nothing ->
            Encode.null

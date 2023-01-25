module Json.Decode.Extra exposing (uuidString)

import Json.Decode as Decode
import Regex


uuidString : Decode.Decoder String
uuidString =
    Decode.string
        |> Decode.andThen
            (\str ->
                if isValidUuid str then
                    Decode.succeed str

                else
                    Decode.fail "Invalid UUID"
            )


isValidUuid : String -> Bool
isValidUuid potentialUuid =
    Regex.contains
        (Maybe.withDefault Regex.never <|
            Regex.fromString "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
        )
        potentialUuid

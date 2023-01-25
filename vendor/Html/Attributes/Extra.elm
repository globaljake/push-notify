module Html.Attributes.Extra exposing (cond, maybe, none)

import Html exposing (Attribute)
import Html.Attributes as Attributes
import Json.Encode as Encode


cond : Bool -> Attribute msg -> Attribute msg
cond bool attr =
    if bool then
        attr

    else
        none


maybe : Maybe (Attribute msg) -> Attribute msg
maybe =
    Maybe.withDefault none


none : Attribute msg
none =
    Attributes.property "" Encode.null

module Ui.Share exposing (onFailure, onSuccess, text, view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Html.Events as Events
import Json.Decode as Decode
import Json.Encode as Encode


type Attribute msg
    = Attribute (Config msg -> Config msg)


view : List (Attribute msg) -> Html msg -> Html msg
view attrs =
    render (List.foldl (\(Attribute attr) l -> attr l) init attrs)


type alias Config msg =
    { text : String
    , onSuccess : Maybe msg
    , onFailure : Maybe msg
    }


init : Config msg
init =
    { text = ""
    , onSuccess = Nothing
    , onFailure = Nothing
    }


render : Config msg -> Html msg -> Html msg
render config inner =
    Html.node "push-notify-ui-share"
        [ Attributes.property "text" (Encode.string config.text)
        , config.onSuccess
            |> Maybe.map (Events.on "success" << Decode.succeed)
            |> Attributes.maybe
        , config.onFailure
            |> Maybe.map (Events.on "failure" << Decode.succeed)
            |> Attributes.maybe
        , Attributes.class "block"
        ]
        [ inner
        ]


text : String -> Attribute msg
text text_ =
    set (\config -> { config | text = text_ })


onSuccess : msg -> Attribute msg
onSuccess onSuccess_ =
    set (\config -> { config | onSuccess = Just onSuccess_ })


onFailure : msg -> Attribute msg
onFailure onFailure_ =
    set (\config -> { config | onFailure = Just onFailure_ })


set : (Config msg -> Config msg) -> Attribute msg
set with =
    Attribute (\config -> with config)

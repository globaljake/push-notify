module Ui.Time exposing
    ( date
    , datetime
    , day
    , daysUntil
    , fullDate
    , fullDay
    , month
    , shortDay
    , shortMonth
    , time
    , weekday
    )

import Html exposing (Html)
import Html.Attributes as Attributes
import Json.Encode as Encode
import Time exposing (Posix)


{-| Ex. "Thursday, September 15"
-}
weekday : Posix -> Html msg
weekday posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "weekday")
        ]
        []


{-| Ex. "September 15"
-}
day : Posix -> Html msg
day posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "day")
        ]
        []


{-| Ex. "September 15, 2022"
-}
fullDay : Posix -> Html msg
fullDay posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "full-day")
        ]
        []


{-| Ex. "Sep 15"
-}
shortDay : Posix -> Html msg
shortDay posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "short-day")
        ]
        []


{-| Ex. "09/15"
-}
date : Posix -> Html msg
date posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "date")
        ]
        []


{-| Ex. "09/15/22"
-}
fullDate : Posix -> Html msg
fullDate posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "full-date")
        ]
        []


{-| Ex. "Sep 2022"
-}
shortMonth : Posix -> Html msg
shortMonth posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "short-month")
        ]
        []


{-| Ex. "September"
-}
month : Posix -> Html msg
month posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "month")
        ]
        []


{-| Ex. "8:00 AM"
-}
time : Posix -> Html msg
time posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "time")
        ]
        []


{-| Ex. "09/15/2022, 8:00 AM"
-}
datetime : Posix -> Html msg
datetime posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "datetime")
        ]
        []


{-| Ex. "6"
-}
daysUntil : Posix -> Html msg
daysUntil posix =
    Html.node "spent-ui-time"
        [ Attributes.property "posix" (Encode.int <| Time.posixToMillis posix)
        , Attributes.property "format" (Encode.string "days-until")
        ]
        []

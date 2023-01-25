module String.Extra exposing (fromIntWithDelimiter, pluralize)


fromIntWithDelimiter : String -> Int -> String
fromIntWithDelimiter delimiter int =
    let
        modBy1000 =
            modBy 1000

        hundreds =
            modBy1000 int

        thousands =
            modBy1000 (int // 1000)

        millions =
            modBy1000 (int // 1000000)

        billions =
            modBy1000 (int // 1000000000)

        isThousands =
            int >= 1000

        isMillions =
            int >= 1000000

        isBillions =
            int >= 1000000000
    in
    (String.join delimiter << List.concat)
        [ if isBillions then
            [ String.fromInt billions ]

          else
            []
        , if isMillions && isBillions then
            [ toPaddedString 3 millions ]

          else if isMillions then
            [ String.fromInt millions ]

          else
            []
        , if isThousands && isMillions then
            [ toPaddedString 3 thousands ]

          else if isThousands then
            [ String.fromInt thousands ]

          else
            []
        , if isThousands then
            [ toPaddedString 3 hundreds ]

          else
            [ String.fromInt hundreds ]
        ]


toPaddedString : Int -> Int -> String
toPaddedString digits val =
    String.padLeft digits '0' (String.fromInt val)


pluralize : String -> String -> Int -> String
pluralize singular plural amount =
    case amount of
        1 ->
            singular

        _ ->
            plural

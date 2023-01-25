module Ui.Avatar exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes



-- STATES


view : { name : String, avatarUrl : Maybe String } -> Html msg
view { name, avatarUrl } =
    Html.div [ Attributes.class "h-full w-full overflow-hidden rounded-md border-2 font-bold border-black flex flex-shrink-0 justify-center items-center" ]
        [ case avatarUrl of
            Just url ->
                Html.img [ Attributes.src url, Attributes.class "w-full h-full object-cover" ] []

            Nothing ->
                Html.text (String.toUpper (String.slice 0 1 name))
        ]

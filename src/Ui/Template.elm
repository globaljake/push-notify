module Ui.Template exposing
    ( Content
    , Template
    , blank
    , content
    , mapContent
    , standard
    , toHtml
    , toTitle
    )

import Html exposing (Html)
import Html.Attributes as Attributes



-- STATE


type Template msg
    = Template (Layout msg) (Content msg)


type Content msg
    = Content ( String, Html msg )


type Layout msg
    = Blank
    | Standard


content : ( String, Html msg ) -> Content msg
content =
    Content


mapContent : (a -> b) -> Content a -> Content b
mapContent f (Content ( title, content_ )) =
    Content ( title, Html.map f content_ )



-- INITIAL STATE


blank : Content msg -> Template msg
blank content_ =
    Template Blank content_


standard : Content msg -> Template msg
standard content_ =
    Template Standard content_



-- OUTPUT


toTitle : Template msg -> String
toTitle (Template _ (Content ( title, _ ))) =
    title


toHtml : Template msg -> Html msg
toHtml (Template layout (Content ( _, htmlContent ))) =
    Html.div [ Attributes.class "w-full" ]
        [ case layout of
            Blank ->
                htmlContent

            Standard ->
                Html.div [ Attributes.class "sm:max-w-md mx-auto" ] [ htmlContent ]
        ]

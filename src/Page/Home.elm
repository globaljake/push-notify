module Page.Home exposing (Model, Msg, init, subscriptions, update, view)

import Data.Budget as Budget exposing (Budget)
import Data.Category as Category exposing (Category)
import Data.Log as Log exposing (Log)
import Data.Money as Money exposing (Money)
import Data.User as User exposing (User)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import RemoteData exposing (RemoteData)
import Session as Session exposing (Session)
import Ui.Share as Share
import Ui.Template as Template



-- STATE


type Model
    = Model Internal


type alias Internal =
    { location : String
    , items : Dict Int String
    }



-- INITIAL STATE


init : Session -> ( Model, Cmd Msg )
init session =
    ( Model { location = "", items = Dict.empty }
    , Cmd.none
    )


items : List ( Int, String )
items =
    [ ( 1, "Blew mud 💨💩" )
    , ( 2, "Soft Serve 🍦" )
    , ( 3, "Pushed Clay \u{1FAE0}" )
    , ( 4, "Window breaker \u{1FAA8}" )
    , ( 5, "Shower after 💩🚿" )
    , ( 6, "Green Eggs and Ham 🍳" )
    , ( 7, "No wiper ✨✨" )
    , ( 8, "Passed out pushing" )
    , ( 9, "Lost 5lbs ⚖️" )
    , ( 10, "Filled the bowl 🥣" )
    , ( 11, "Floater \u{1F6DF}" )
    , ( 12, "Pebble Beach ⛳️" )
    ]



-- INPUT


type Msg
    = EnteredLocation String
    | ClickedItem ( Int, String )



-- TRANSITION


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    Tuple.mapFirst Model <|
        case msg of
            EnteredLocation location ->
                ( { model | location = location }, Cmd.none )

            ClickedItem ( key, item ) ->
                ( { model
                    | items =
                        case Dict.get key model.items of
                            Just _ ->
                                Dict.remove key model.items

                            Nothing ->
                                Dict.insert key item model.items
                  }
                , Cmd.none
                )



-- OUTPUT


view : Session -> Model -> Template.Content Msg
view session (Model model) =
    Template.content ( "Home", viewContent session model )


viewContent : Session -> Internal -> Html Msg
viewContent session model =
    Html.div [ Attributes.class "p-4  space-y-6" ]
        [ Html.div [ Attributes.class "text-center" ]
            [ Html.div [ Attributes.class "flex justify-center text-center" ]
                [ Html.img [ Attributes.class "w-24", Attributes.src "/images/logo.png" ] []
                ]
            , Html.span [ Attributes.class "block font-bold text-4xl pt-3" ]
                [ Html.text "Push Notify"
                ]
            ]
        , items
            |> List.map (viewItemButton model)
            |> Html.div [ Attributes.class "grid grid-cols-3 gap-4" ]
        , Html.input
            [ Events.onInput EnteredLocation
            , Attributes.class "border border-white text-white rounded p-3 bg-transparent w-full"
            , Attributes.placeholder "Location"
            ]
            []
        , viewShareButton model
        ]


viewItemButton : Internal -> ( Int, String ) -> Html Msg
viewItemButton model ( key, itemName ) =
    let
        isSelected =
            case Dict.get key model.items of
                Just _ ->
                    True

                Nothing ->
                    False
    in
    Html.button
        [ Events.onClick (ClickedItem ( key, itemName ))
        , Attributes.classList
            [ ( "border border-white rounded-md px-4 font-semibold text-sm h-20 leading-tight", True )
            , ( "bg-[#663217]", isSelected )
            ]
        ]
        [ Html.text itemName
        ]


viewShareButton : Internal -> Html msg
viewShareButton model =
    Share.view [ Share.text (toShareMessage model) ]
        (Html.div [ Attributes.class "flex flex-col items-center justify-center" ]
            [ Html.button [ Attributes.class "border border-white rounded-md p-4 font-semibold w-full" ] [ Html.text "Share" ]
            ]
        )


toShareMessage : Internal -> String
toShareMessage model =
    let
        itemMessage =
            model.items |> Dict.values |> String.join ", "
    in
    String.join ""
        [ "PUSH 💨 NOTIFY 💩 @ [TIME]"
        , if String.isEmpty model.location then
            ""

          else
            " | location: " ++ model.location
        , if String.isEmpty itemMessage then
            ""

          else
            " | status: " ++ itemMessage
        ]


subscriptions : Model -> Sub Msg
subscriptions (Model model) =
    Sub.none

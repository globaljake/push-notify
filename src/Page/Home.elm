module Page.Home exposing (Model, Msg, init, subscriptions, update, view)

import Array
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Extra as Html
import RemoteData exposing (RemoteData)
import Session exposing (Session)
import Ui.Share as Share
import Ui.Template as Template



-- STATE


type Model
    = Model Internal


type alias Internal =
    { location : String
    , items : List Int
    }



-- INITIAL STATE


init : Session -> ( Model, Cmd Msg )
init session =
    ( Model { location = "", items = [] }
    , Cmd.none
    )


itemDict : Dict Int String
itemDict =
    [ "Push clay 🪵"
    , "Soft serve 🍦"
    , "Blow mud 🌋"
    , "Ride the snake 🐍"
    , "Green monster 🏟️"
    , "Floater 🛟"
    , "Pebble beach ⛳️"
    , "Shippin' bricks 🧱"
    , "Liquidump 🌊"
    , "Jackson Pollock 🎨"
    , "Beached whale 🐋"
    , "Spittin' fire 🎤🔥"
    , "$5 footlong 🥖"
    , "Filled the bowl 🥣"
    , "Very Messi ⚽️"
    , "No Wiper ✨✨"
    , "Shower after 🚿"
    , "Like clockwork ☕️"
    , "Passed out 🥵 pushing"
    , "Lost 5lbs ⚖️"
    , "I gotta stop 😩"
    , "Big honk 📢"
    , "Birthday suit 🍑"
    , "Courtesy flush ❤️"
    , "Just gave birth 👶"
    , "Nervous poops 😅"
    , "Proud father 👨\u{200D}🦰"
    , "Unfinished business 😔"
    , "Trombone solo 📯"
    , "Didn't pee 🚫"
    , "Gambled and lost 🎲"
    , "Needed a break ⌛️"
    , "Held it in too long 🫥"
    , "Relieved from doodie 🎖️"
    , "Someone elses problem 💀"
    , "Pooper Truper 🚔"
    , "Splash zone 🐳"
    , "Need for speed 🏎️"
    , "Hunt for red Oct 🦑"
    , "Unfamiliar smell 🥸"
    , "Legs fell asleep 💤"
    , "Multi-Flusher 🚽"
    , "Stopped up 🧀"
    , "Praying 🙏"
    , "Found gold 🌽"
    , "Disgusted myself 🤢"
    , "Used bidet ⛲️"
    , "False alarm 🚨"
    ]
        |> List.indexedMap (\i v -> ( i + 1, v ))
        |> Dict.fromList



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
                        if List.member key model.items then
                            List.filter ((/=) key) model.items

                        else
                            List.concat [ model.items, [ key ] ]
                  }
                , Cmd.none
                )



-- OUTPUT


view : Session -> Model -> Template.Content Msg
view session (Model model) =
    Template.content ( "Push Notify", viewContent session model )


viewContent : Session -> Internal -> Html Msg
viewContent session model =
    Html.div [ Attributes.class "p-6 space-y-6" ]
        [ Html.div [ Attributes.class "text-center" ]
            [ Html.div [ Attributes.class "flex justify-center text-center" ]
                [ Html.img [ Attributes.class "w-24", Attributes.src "/images/logo.png" ] []
                ]
            , Html.span [ Attributes.class "block font-bold text-4xl pt-3" ]
                [ Html.text "Push 💨 Notify"
                ]
            ]
        , itemDict
            |> Dict.toList
            |> List.map (viewItemButton model)
            |> Html.div [ Attributes.class "grid grid-cols-3 gap-4" ]
        , viewHeader "Location"
        , Html.input
            [ Events.onInput EnteredLocation
            , Attributes.class "border border-white text-white rounded p-3 bg-transparent w-full"
            , Attributes.placeholder "Your current location"
            ]
            []
        , viewShareButton model

        -- , Html.div [] [ Html.text <| toShareMessage model ]
        ]


viewHeader : String -> Html msg
viewHeader text =
    Html.div []
        [ Html.span [ Attributes.class "font-semibold" ] [ Html.text text ]
        ]


viewItemButton : Internal -> ( Int, String ) -> Html Msg
viewItemButton model ( key, itemName ) =
    let
        isSelected =
            List.member key model.items

        order =
            model.items
                |> List.indexedMap Tuple.pair
                |> List.foldl
                    (\( i, v ) acc ->
                        if v == key then
                            i + 1

                        else
                            acc
                    )
                    0
    in
    Html.div [ Attributes.class "relative" ]
        [ Html.button
            [ Events.onClick (ClickedItem ( key, itemName ))
            , Attributes.classList
                [ ( "border border-white rounded-md px-3 w-full text-center font-semibold text-sm h-20 leading-snug", True )
                , ( "bg-[#663217]", isSelected )
                ]
            ]
            [ Html.text itemName
            ]
        , Html.viewIf isSelected <|
            Html.div [ Attributes.class "absolute top-0 right-0 pointer-events-none" ]
                [ Html.div [ Attributes.class "-mt-2 -mr-2 rounded-full font-bold bg-[#663217] border border-white flex justify-center items-center w-5 h-5 text-xs" ]
                    [ Html.text (String.fromInt order)
                    ]
                ]
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
            model.items
                |> List.filterMap (\k -> Dict.get k itemDict)
                |> String.join ", "
    in
    String.join ""
        [ "💩 PUSH NOTIFY @ [TIME]"
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

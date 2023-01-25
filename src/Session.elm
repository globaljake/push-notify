port module Session exposing
    ( Msg
    , Session
    , clear
    , make
    , navKey
    , subscriptions
    , update
    )

import Browser.Navigation as Navigation
import Json.Encode as Encode



-- STATE


type Session
    = Guest Navigation.Key
    | LoggedIn Navigation.Key Internal


type alias Internal =
    {}



-- INITIAL STATE


make : Navigation.Key -> Maybe Internal -> Session
make navKey_ maybeInternal =
    case maybeInternal of
        Just internal ->
            LoggedIn navKey_ internal

        Nothing ->
            LoggedIn navKey_ {}



-- INPUT


type Msg
    = NoOp



-- | GotViewer Viewer
-- | ClearViewer


subscriptions : Session -> Sub Msg
subscriptions session =
    Sub.batch
        [-- Viewer.onChangeFromOtherTab
         -- (\result ->
         --     case result of
         --         Ok viewer_ ->
         --             GotViewer viewer_
         --         Err _ ->
         --             ClearViewer
         -- )
        ]



-- TRANSITION


update : Msg -> Session -> ( Session, Cmd Msg )
update msg session =
    case msg of
        NoOp ->
            ( session, Cmd.none )



-- GotViewer viewer_ ->
--     ( LoggedIn (navKey session) { viewer = viewer_, frequency = frequency session }
--     , Cmd.none
--     )
-- ClearViewer ->
--     ( Guest (navKey session), Cmd.none )
-- OUTPUT


navKey : Session -> Navigation.Key
navKey session =
    case session of
        LoggedIn navKey_ _ ->
            navKey_

        Guest navKey_ ->
            navKey_



-- PORTS


port sessionOutgoingMessage : Maybe Encode.Value -> Cmd msg


clear : Cmd msg
clear =
    sessionOutgoingMessage Nothing

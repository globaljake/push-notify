module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Flags as Flags exposing (Flags)
import Html
import Json.Encode as Encode
import Page as Page exposing (Page)
import Session as Session exposing (Session)
import Url exposing (Url)



-- STATE


type Model
    = Model Session Page



-- INITIAL STATE


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    -- let
    --     maybeSessionInternal =
    --         Maybe.map (\v -> { viewer = v, frequency = flags.frequency }) flags.viewer
    -- in
    initChangedUrl (Session.make navKey Nothing) url


initChangedUrl : Session -> Url -> ( Model, Cmd Msg )
initChangedUrl session url =
    let
        ( page, pageCmd ) =
            Page.init url session
    in
    ( Model session page
    , Cmd.map PageMsg pageCmd
    )



-- INPUT


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | SessionMsg Session.Msg
    | PageMsg Page.Msg



-- TRANSITION


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model session page) =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( Model session page
                    , Navigation.pushUrl (Session.navKey session) (Url.toString url)
                    )

                Browser.External href ->
                    ( Model session page
                    , Navigation.load href
                    )

        ChangedUrl url ->
            initChangedUrl session url

        SessionMsg subMsg ->
            Session.update subMsg session
                |> Tuple.mapBoth (\s -> Model s page) (Cmd.map SessionMsg)

        PageMsg subMsg ->
            Page.update session subMsg page
                |> Tuple.mapBoth (\p -> Model session p) (Cmd.map PageMsg)



-- OUTPUT


view : Model -> Browser.Document Msg
view (Model session page) =
    { title = Page.title session page
    , body =
        [ Html.main_ []
            [ Page.view session page
                |> Html.map PageMsg
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions (Model session page) =
    Sub.batch
        [ Session.subscriptions session
            |> Sub.map SessionMsg
        , Page.subscriptions page
            |> Sub.map PageMsg
        ]



-- MAIN


main : Program Encode.Value Model Msg
main =
    Browser.application
        { init = init << Flags.fromValue
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }

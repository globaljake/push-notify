module Page exposing (Msg, Page, init, subscriptions, title, update, view)

import Html exposing (Html)
import Page.Home as Home
import Page.NotFound as NotFound
import Route as Route exposing (Route)
import Session as Session exposing (Session)
import Ui.Template as Template exposing (Template)
import Url exposing (Url)



-- STATE


type Page
    = NotFound
    | Home Home.Model


init : Url -> Session -> ( Page, Cmd Msg )
init url session =
    case Route.fromUrl url of
        Nothing ->
            ( NotFound, Cmd.none )

        Just Route.Home ->
            Home.init session
                |> Tuple.mapBoth Home (Cmd.map HomeMsg)



-- INPUT


type Msg
    = ClickedBack
    | HomeMsg Home.Msg



-- TRANSITION


update : Session -> Msg -> Page -> ( Page, Cmd Msg )
update session msg page =
    case ( msg, page ) of
        ( ClickedBack, _ ) ->
            ( page, Route.back (Session.navKey session) )

        ( HomeMsg subMsg, Home subModel ) ->
            Home.update subMsg subModel
                |> Tuple.mapBoth Home (Cmd.map HomeMsg)

        _ ->
            ( page, Cmd.none )



-- OUTPUT


template : Session -> Page -> Template Msg
template session page =
    case page of
        NotFound ->
            Template.blank NotFound.view

        Home subModel ->
            Home.view session subModel
                |> Template.mapContent HomeMsg
                |> Template.standard


title : Session -> Page -> String
title session page =
    Template.toTitle (template session page)


view : Session -> Page -> Html Msg
view session page =
    Template.toHtml (template session page)


subscriptions : Page -> Sub Msg
subscriptions page =
    case page of
        NotFound ->
            Sub.none

        Home subModel ->
            Home.subscriptions subModel
                |> Sub.map HomeMsg

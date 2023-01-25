module Data.User exposing
    ( User
    , avatarUrl
    , decoder
    , displayName
    , email
    , fragment
    , id
    , lastLoggedCategoryId
    , name
    , viewAvatar
    )

import Data.CategoryId as CategoryId exposing (CategoryId)
import Data.UserId as UserId exposing (UserId)
import Graphql
import Html exposing (Html)
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Ui.Avatar as Avatar



-- TYPES


type User
    = User Internal


type alias Internal =
    { id : UserId
    , email : String
    , name : Maybe String
    , avatarUrl : Maybe String
    , lastLoggedCategoryId : Maybe CategoryId
    }



-- PROPERTIES


id : User -> UserId
id (User user) =
    user.id


email : User -> String
email (User user) =
    user.email


name : User -> Maybe String
name (User user) =
    user.name


displayName : User -> String
displayName (User user) =
    user.name
        |> Maybe.withDefault user.email


avatarUrl : User -> Maybe String
avatarUrl (User user) =
    user.avatarUrl



-- user.avatarUrl


lastLoggedCategoryId : User -> Maybe CategoryId
lastLoggedCategoryId (User user) =
    user.lastLoggedCategoryId



-- OUTPUT


viewAvatar : User -> Html msg
viewAvatar user =
    Avatar.view { name = displayName user, avatarUrl = avatarUrl user }



-- SERIALIZATION


decoder : Decode.Decoder User
decoder =
    Decode.succeed Internal
        |> Decode.required "id" UserId.decoder
        |> Decode.required "email" Decode.string
        |> Decode.required "name" (Decode.nullable Decode.string)
        |> Decode.required "avatarUrl" (Decode.nullable Decode.string)
        |> Decode.required "lastLoggedCategoryId" (Decode.nullable CategoryId.decoder)
        |> Decode.map User


fragment : Graphql.Fragment
fragment =
    Graphql.fragment
        """
        fragment UserFields on User {
          id
          email
          name
          avatarUrl
          lastLoggedCategoryId
        }
        """
        []

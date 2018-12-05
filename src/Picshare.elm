module Picshare exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)

type alias Model = { url : String, caption : String, liked: Bool }

initialModel : Model
initialModel =
  {
    url = "https://programming-elm.com/1.jpg",
    caption = "Surfing",
    liked = False
  }

type Msg =
  ToggleLike

update : Msg -> Model -> Model
update msg model =
  case msg of
    ToggleLike -> { model | liked = not model.liked }

viewLikeButton : Model -> Html Msg
viewLikeButton model =
  let
    buttonCls =
      if model.liked then "fas fa-heart"
      else "far fa-heart"
  in
  a [ class "like-button", onClick ToggleLike ]
    [
      i [ class buttonCls ] []
    ]

viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
  div [ class "detailed-photo" ]
    [
      figure [ class "image" ]
        [
          img [ src model.url ] [],
          div [ class "photo-info" ]
            [
              h2 [ class "subtitle photo-caption" ]
                [
                  text model.caption,
                  viewLikeButton model
                ]
            ]
        ]
    ]

view : Model -> Html Msg
view model =
  div []
    [
      nav [ class "navbar" ]
        [
          div [ class "navbar-brand" ]
            [
              h1 [ class "title navbar-item" ] [ text "Picshare" ]
            ]
        ],
      viewDetailedPhoto model
    ]

main : Program () Model Msg
main = Browser.sandbox
  {
    init = initialModel,
    view = view,
    update = update
  }
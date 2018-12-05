module Picshare exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)

initialModel : { url : String, caption : String, liked: Bool }
initialModel =
  {
    url = "https://programming-elm.com/1.jpg",
    caption = "Surfing",
    liked = False
  }

type Msg =
  Like
  | Unlike

update : Msg -> { url : String, caption : String, liked : Bool } -> { url : String, caption : String, liked : Bool }
update msg model =
  case msg of
    Like -> { model | liked = True }
    Unlike -> { model | liked = False }

viewDetailedPhoto : { url : String, caption : String, liked : Bool } -> Html Msg
viewDetailedPhoto model =
  let 
    buttonCls =
      if model.liked then
        "fas fa-heart"
      else
        "far fa-heart"
    msg =
      if model.liked then Unlike else Like
  in
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
                  a [ class "like-button", onClick msg ]
                    [
                      i [ class buttonCls ] []
                    ]
                ]
            ]
        ]
    ]

view : { url : String, caption : String, liked : Bool } -> Html Msg
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

main : Program () { url : String, caption : String, liked : Bool } Msg
main = Browser.sandbox
  {
    init = initialModel,
    view = view,
    update = update
  }
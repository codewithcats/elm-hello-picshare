module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)

initialModel : { url : String, caption : String, liked: Bool }
initialModel =
  {
    url = "https://programming-elm.com/1.jpg",
    caption = "Surfing",
    liked = False
  }

viewDetailedPhoto : { url : String, caption : String, liked : Bool } -> Html msg
viewDetailedPhoto model =
  let 
    buttonCls =
      if model.liked then
        "fas fa-heart"
      else
        "far fa-heart"
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
                  a [ class "like-button" ]
                    [
                      i [ class buttonCls ] []
                    ]
                ]
            ]
        ]
    ]

view : { url : String, caption : String, liked : Bool } -> Html msg
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

main : Html msg
main = view initialModel
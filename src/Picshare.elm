module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)

viewDetailedPhoto : String -> String -> Html msg
viewDetailedPhoto url caption =
  div [ class "detailed-photo" ]
    [
      figure [ class "image" ]
        [
          img [ src url ] [],
          div [ class "photo-info" ]
            [
              h2 [ class "subtitle photo-caption" ] [ text caption ]
            ]
        ]
    ]

main : Html msg
main =
  div []
    [
      nav [ class "navbar" ]
        [
          div [ class "navbar-brand" ]
            [
              h1 [ class "title navbar-item" ] [ text "Picshare" ]
            ]
        ],
      viewDetailedPhoto "https://programming-elm.com/1.jpg" "Surfing"
    ]
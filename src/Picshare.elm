module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)

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
      div []
        [
          figure [ class "image" ]
            [
              img [ src "https://programming-elm.com/1.jpg" ] []
            ]
        ]
    ]
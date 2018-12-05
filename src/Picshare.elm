module Picshare exposing (main)

import Html exposing (Html, nav, div, h1, text)
import Html.Attributes exposing (class)

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
        ]
    ]
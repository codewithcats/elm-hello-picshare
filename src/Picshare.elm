module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)

initialModel : { url : String, caption : String }
initialModel =
  {
    url = "https://programming-elm.com/1.jpg",
    caption = "Surfing"
  }

viewDetailedPhoto : { url : String, caption : String } -> Html msg
viewDetailedPhoto model =
  div [ class "detailed-photo" ]
    [
      figure [ class "image" ]
        [
          img [ src model.url ] [],
          div [ class "photo-info" ]
            [
              h2 [ class "subtitle photo-caption" ] [ text model.caption ]
            ]
        ]
    ]

view : { url : String, caption : String } -> Html msg
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
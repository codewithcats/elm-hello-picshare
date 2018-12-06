module Picshare exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src, type_, placeholder, disabled, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)

type alias Id = Int

type alias Photo =
  {
    id : Id,
    url : String,
    caption : String,
    liked : Bool,
    comments : List String,
    newComment : String 
  }

type alias Model = Photo

photoDecoder : Decoder Photo
photoDecoder =
  succeed Photo
    |> required "id" int
    |> required "url" string
    |> required "caption" string
    |> required "liked" bool
    |> required "comments" (list string)
    |> hardcoded ""

initialModel : Model
initialModel =
  {
    id = 1,
    url = "https://programming-elm.com/1.jpg",
    caption = "Surfing",
    liked = False,
    comments =
      [
        "Hello"
      ],
    newComment = ""
  }

type Msg =
  ToggleLike
  | UpdateComment String
  | SaveComment

saveNewComment : Model -> Model
saveNewComment model =
  case String.trim model.newComment of
    "" -> model
    _ ->
      {
        model |
        comments = model.comments ++ [ model.newComment ],
        newComment = ""
      }

update : Msg -> Model -> Model
update msg model =
  case msg of
    ToggleLike -> { model | liked = not model.liked }
    UpdateComment comment -> { model | newComment = comment }
    SaveComment -> saveNewComment model

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

viewComment : String -> Html Msg
viewComment comment =
  div []
    [
      strong [] [ text "Comment: " ],
      text comment
    ]

viewInput : String -> String -> (String -> Msg) -> Html Msg
viewInput value_ placeholderText onInput_ =
  div [ class "control" ]
    [
      input
        [
          class "input",
          type_ "text",
          value value_,
          placeholder placeholderText,
          onInput onInput_
        ]
        []
    ]

viewInputField : String -> String -> (String -> Msg) -> Html Msg
viewInputField value placeholderText onInput =
  div [ class "field" ]
    [
      viewInput value placeholderText onInput
    ]

viewCommentForm : Model -> Html Msg
viewCommentForm model =
  form
    [
      class "photo-comment-form",
      onSubmit SaveComment
    ]
    [
      viewInputField model.newComment "Add comment..." UpdateComment,
      div [ class "field" ]
        [
          div [ class "control" ]
            [
              button
                [
                  class "button is-link",
                  disabled (String.isEmpty model.newComment)
                ]
                [ text "Add" ]
            ]
        ]
    ]

viewCommentList : List String -> Html Msg
viewCommentList comments =
  case comments of
    [] -> text ""
    _ ->
      div [ class "comment-list" ]
        [
          ul [] (List.map viewComment comments)
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
      viewDetailedPhoto model,
      viewCommentList model.comments,
      viewCommentForm model
    ]

main : Program () Model Msg
main = Browser.sandbox
  {
    init = initialModel,
    view = view,
    update = update
  }
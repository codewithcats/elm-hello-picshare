module Picshare exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src, type_, placeholder, disabled, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Http

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

type alias Model =
  {
    photo : Maybe Photo
  }

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
    photo =
      Just
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
  }

type Msg =
  ToggleLike
  | UpdateComment String
  | SaveComment
  | LoadFeed (Result Http.Error Photo)

fetchFeed : Cmd Msg
fetchFeed =
  Http.get
    {
      url = "https://programming-elm.com/feed/1",
      expect = Http.expectJson LoadFeed photoDecoder
    }

init : () -> (Model, Cmd Msg)
init () = (initialModel, fetchFeed)

saveNewComment : Photo -> Photo
saveNewComment photo =
  case String.trim photo.newComment of
    "" -> photo
    _ ->
      {
        photo |
        comments = photo.comments ++ [ photo.newComment ],
        newComment = ""
      }

updateFeed : (Photo -> Photo) -> Maybe Photo -> Maybe Photo
updateFeed updatePhoto maybePhoto =
  Maybe.map updatePhoto maybePhoto

toggleLike : Photo -> Photo
toggleLike photo =
  { photo | liked = not photo.liked }

updateComment : String -> Photo -> Photo
updateComment comment photo =
  { photo | newComment = comment }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ToggleLike -> ({ model | photo = updateFeed toggleLike model.photo }, Cmd.none)
    UpdateComment comment -> ({ model | photo = updateFeed (updateComment comment) model.photo }, Cmd.none)
    SaveComment -> ({ model | photo = updateFeed saveNewComment model.photo }, Cmd.none)
    LoadFeed _ -> (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

viewLikeButton : Photo -> Html Msg
viewLikeButton photo =
  let
    buttonCls =
      if photo.liked then "fas fa-heart"
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

viewCommentForm : Photo -> Html Msg
viewCommentForm photo =
  form
    [
      class "photo-comment-form",
      onSubmit SaveComment
    ]
    [
      viewInputField photo.newComment "Add comment..." UpdateComment,
      div [ class "field" ]
        [
          div [ class "control" ]
            [
              button
                [
                  class "button is-link",
                  disabled (String.isEmpty photo.newComment)
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

viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
  div [ class "detailed-photo" ]
    [
      figure [ class "image" ]
        [
          img [ src photo.url ] [],
          div [ class "photo-info" ]
            [
              h2 [ class "subtitle photo-caption" ]
                [
                  text photo.caption,
                  viewLikeButton photo
                ]
            ],
          viewCommentList photo.comments,
          viewCommentForm photo
        ]
    ]

viewFeed : Maybe Photo -> Html Msg
viewFeed maybePhoto =
  case maybePhoto of
    Just photo -> viewDetailedPhoto photo
    _ -> text ""

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
      viewFeed model.photo
    ]

main : Program () Model Msg
main = Browser.element
  {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }
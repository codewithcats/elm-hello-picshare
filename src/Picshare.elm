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

type alias Feed =
  List Photo

type alias Model =
  {
    feed : Maybe Feed
  }

initialModel : Model
initialModel =
  {
    feed =
      Nothing
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

type Msg =
  ToggleLike Id
  | UpdateComment Id String
  | SaveComment Id
  | LoadFeed (Result Http.Error Feed)

fetchFeed : Cmd Msg
fetchFeed =
  Http.get
    {
      url = "https://programming-elm.com/feed",
      expect = Http.expectJson LoadFeed (list photoDecoder)
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

updatePhotoById : (Photo -> Photo) -> Id -> Feed -> Feed
updatePhotoById updatePhoto id feed =
  List.map
    (\photo ->
      if photo.id == id then updatePhoto photo
      else photo
    )
    feed

updateFeed : (Photo -> Photo) -> Id -> Maybe Feed -> Maybe Feed
updateFeed updatePhoto id maybeFeed =
  Maybe.map (updatePhotoById updatePhoto id) maybeFeed

toggleLike : Photo -> Photo
toggleLike photo =
  { photo | liked = not photo.liked }

updateComment : String -> Photo -> Photo
updateComment comment photo =
  { photo | newComment = comment }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ToggleLike id -> ({ model | feed = updateFeed toggleLike id model.feed }, Cmd.none)
    UpdateComment id comment -> ({ model | feed = updateFeed (updateComment comment) id model.feed }, Cmd.none)
    SaveComment id -> ({ model | feed = updateFeed saveNewComment id model.feed }, Cmd.none)
    LoadFeed (Ok feed) -> ({ model | feed = Just feed }, Cmd.none)
    LoadFeed (Err _) -> (model, Cmd.none)

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
  a
    [
      class "like-button",
      onClick (ToggleLike photo.id)
    ]
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
      onSubmit (SaveComment photo.id)
    ]
    [
      viewInputField photo.newComment "Add comment..." (UpdateComment photo.id),
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

viewFeed : Maybe Feed -> Html Msg
viewFeed maybeFeed =
  case maybeFeed of
    Just feed ->
      div [] (List.map viewDetailedPhoto feed)
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
      viewFeed model.feed
    ]

main : Program () Model Msg
main = Browser.element
  {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }
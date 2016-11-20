module View.Pages.Home exposing (view)

import Html exposing (Html,div,h1,button,table,tr,td,input)
import Html.Attributes exposing (class,classList,style,placeholder,autofocus,value)
import Html.Events exposing (onClick,onInput)

import Svg exposing (svg, polyline)
import Svg.Attributes

import Dict
import String
import Debug exposing (log)

import Model exposing (..)
import Model.Page exposing (Page(..))
import View.Common exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view model =
  div []
    [ Html.header [] [ h1 [] [ Html.text "Special Type" ] ]
    , Html.main' [] [ viewMainContent model ]
    , Html.footer [] [ viewProfile model ]
    ]


viewMainContent : Model -> Html Msg
viewMainContent model =
  case model.exercise of
    Nothing ->
      button [ class "PlayButton", onClick RandomizeExercise ] [ Html.text "Exercise" ]

    Just exercise ->
      viewPracticePanel exercise


viewPracticePanel : Exercise -> Html Msg
viewPracticePanel exercise =
  div
    [ class "ExercisePanel" ]
    [ div [ class "ExercisePanel__Target" ] [ Html.text exercise.target ]
    , input
        [ placeholder "Type what it says above"
        , autofocus True
        , value exercise.userInput
        , onInput ChangeInput
        , classList [ ("ExercisePanel__Input", True)
                    , ("ExercisePanel__Input--Error", String.startsWith exercise.userInput exercise.target |> not)
                    ]
        ]
        []
    ]


viewProfile : Model -> Html Msg
viewProfile ({profile} as model) =
  let
      scoreItems = Dict.toList profile |> List.indexedMap (viewScoreItem model)
  in
      div
        [ class "ScoreList" ]
        scoreItems


viewScoreItem : Model -> Int -> (Char, List Bool) -> Html Msg
viewScoreItem {profile} index (char,history) =
  div
    [ class "ScoreItem"
    , style [("left", ((index |> toFloat) / (Dict.size profile |> toFloat) * 96.0 + 2.0 |> toString)++"%")] ]
    [ viewPlant history
    , div [ class "ScoreItem__Char" ] [ Html.text (String.fromChar char) ]
    ]


viewPlant : List Bool -> Html Msg
viewPlant history =
  let
    height = (List.length history) * 10
    path =
      polyline
        [ Svg.Attributes.points (history |> List.indexedMap (point height) |> String.join " ")
        , Svg.Attributes.style "fill:none;stroke:#222;stroke-width:3" ]
        []
  in
    svg
      [ Svg.Attributes.class "ScoreItem__Plant"
      , Svg.Attributes.version "1.1"
      , Svg.Attributes.width "20"
      , Svg.Attributes.height (toString height)
      , Svg.Attributes.viewBox ("0 0 20 "++(toString height)) ]
      [ path ]


point : Int -> Int -> Bool -> String
point height index hit =
  let
      y v =
        height - v |> toString
  in
      if hit then
        "10,"++(index * 10 |> y)++" 10,"++(index * 10 + 10 |> y)
      else
        "10,"++(index * 10 |> y)++" 0,"++(index * 10 + 3 |> y) ++ " 20,"++(index * 10 + 7 |> y)

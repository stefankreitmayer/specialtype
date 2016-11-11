module View.Pages.Home exposing (view)

import Html exposing (Html,div,h1,button,table,tr,td,input)
import Html.Attributes exposing (class,classList,placeholder,autofocus,value)
import Html.Events exposing (onClick,onInput)

import Dict
import String

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
      button [ class "PlayButton", onClick StartExercise ] [ Html.text "Exercise" ]

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
viewProfile {profile} =
  let
      chars = Dict.keys profile |> List.map (\char -> cell "Char" (String.cons char ""))
      hitcounts = Dict.values profile |> List.map (\{hits} -> hits |> toString |> cell "Hits")
      misscounts = Dict.values profile |> List.map (\{misses} -> misses |> toString |> cell "Misses")
  in
      table
        [ class "Profile__Board" ]
        [ (tr [] chars)
        , (tr [] hitcounts)
        , (tr [] misscounts)
        ]


cell : String -> String -> Html Msg
cell modifier str =
  td
    [ class ("Profile__Cell Profile__Cell--" ++ modifier) ]
    [ Html.text str ]

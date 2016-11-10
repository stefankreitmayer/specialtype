module View.Pages.Home exposing (view)

import Html exposing (Html,div,h1,button,table,tr,td)
import Html.Attributes exposing (id,class)
import Html.Events exposing (onClick)

import Dict
import String

import Model exposing (..)
import Model.Page exposing (Page(..))
import View.Common exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view model =
  div []
    [ Html.main' [] (viewMainContent model)
    , Html.footer [] [ viewProfile model ]
    ]


viewMainContent : Model -> List (Html Msg)
viewMainContent model =
  [ h1 [] [ Html.text "Special Type" ]
  , button [ onClick (Navigate Play) ]
    [ Html.text "Play" ]
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

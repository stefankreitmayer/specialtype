module Msg exposing (..)

import Http exposing (..)

import Model exposing (..)
import Model.Page exposing (Page(..))


type Msg
  = Navigate Page
  | RandomizeExercise
  | NewExercise (String,String,String)
  | ChangeInput String


subscriptions : Model -> Sub Msg
subscriptions model =
  [] |> Sub.batch

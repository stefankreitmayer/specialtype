module Update exposing (..)

import Task
import Navigation

import Model exposing (..)
import Model.Page exposing (Page(..))
import Msg exposing (..)

import Debug exposing (log)


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Navigate page ->
      let
          pathname =
            case page of
              Home ->
                "/"

              Play ->
                "/play"
          model' = { model | currentPage = page }
      in
          (model', Navigation.newUrl pathname)

    StartExercise ->
      let
          model' = { model | exercise = Just newExercise }
      in
          (model', Cmd.none)


    ChangeInput input ->
      let
          model' =
            case model.exercise of
              Nothing ->
                model

              Just exercise ->
                let
                    exercise' =
                      if input == exercise.target then
                          Nothing
                      else
                          Just { exercise | userInput = input }
                in
                    { model | exercise = exercise' }
      in
          (model', Cmd.none)


urlUpdate : Page -> Model -> (Model, Cmd Msg)
urlUpdate page model =
  let
      model' = { model | currentPage = page }
  in
      (model', Cmd.none)

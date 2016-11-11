module Update exposing (..)

import Task
import Navigation
import String
import Dict

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
          model' = { model | exercise = Just (newExercise model.profile) }
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
                    inputLength = String.length input
                    profile' =
                      if inputLength > exercise.progress then
                          let
                              isCorrect = String.startsWith input exercise.target
                              targetChar = List.take inputLength (exercise.target |> String.toList) |> List.reverse |> List.head |> Maybe.withDefault 'x'
                          in
                              if isCorrect then
                                  countAsHit targetChar model.profile
                              else
                                  countAsMiss targetChar model.profile
                      else
                          model.profile
                    progress' = inputLength |> max exercise.progress
                    exercise' =
                      if input == exercise.target then
                          Just (newExercise profile')
                      else
                          Just { exercise | userInput = input
                                          , progress = progress' }
                in
                    { model | profile = profile'
                            , exercise = exercise' }
      in
          (model', Cmd.none)


urlUpdate : Page -> Model -> (Model, Cmd Msg)
urlUpdate page model =
  let
      model' = { model | currentPage = page }
  in
      (model', Cmd.none)


countAsHit : Char -> Profile -> Profile
countAsHit key profile =
  let
      oldScore =
        Dict.get key profile
        |> Maybe.withDefault (Score 0 0) -- won't happen
      newScore = { oldScore | hits = oldScore.hits + 1 }
  in
      Dict.insert key newScore profile


countAsMiss : Char -> Profile -> Profile
countAsMiss key profile =
  let
      oldScore =
        Dict.get key profile
        |> Maybe.withDefault (Score 0 0) -- won't happen
      newScore = { oldScore | misses = oldScore.misses + 1 }
  in
      Dict.insert key newScore profile

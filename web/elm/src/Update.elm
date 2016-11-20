module Update exposing (..)

import Task
import Navigation
import String
import Dict
import Random

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

    RandomizeExercise ->
      (model, Random.generate NewExercise (Random.int 0 (String.length allCharacters)))

    NewExercise firstCharIndex ->
      let
          model' = { model | exercise = Just (newExercise firstCharIndex model.profile) }
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
                              Dict.update targetChar (addToHistory isCorrect) model.profile
                      else
                          model.profile
                    progress' = inputLength |> max exercise.progress
                    exercise' =
                        Just { exercise | userInput = input
                                        , progress = progress' }
                in
                    { model | profile = profile'
                            , exercise = exercise' }

      in
          if isExerciseComplete model'.exercise then
            update RandomizeExercise model'
          else
            (model', Cmd.none)


urlUpdate : Page -> Model -> (Model, Cmd Msg)
urlUpdate page model =
  let
      model' = { model | currentPage = page }
  in
      (model', Cmd.none)


addToHistory : Bool -> Maybe (List Bool) -> Maybe (List Bool)
addToHistory hit maybeHistory =
  case maybeHistory of
    Just history ->
      Just (history ++ [ hit ])

    Nothing ->
      Nothing


newExercise : Int -> Profile -> Exercise
newExercise firstCharIndex profile =
  let
      indexA = firstCharIndex
      indexB = 1
      indexC = 2
      a = allCharacters |> String.dropLeft indexA |> String.left 1
      b = allCharacters |> String.dropLeft indexB |> String.left 1
      c = allCharacters |> String.dropLeft indexC |> String.left 1
      target = a++a++a++a++b++b++b++b++a++a++a++a++c++c++c++c++b++b++c++c++a++a++b++b++c++c++b++b++a++b++a++c++a++b
  in
      { target = target
      , userInput = ""
      , progress = 0 }

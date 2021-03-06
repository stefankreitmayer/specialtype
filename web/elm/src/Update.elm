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
      (model, Random.generate NewExercise threeRandomCharactersAsStrings)

    NewExercise (a,b,c) ->
      let
          badRandomValues = a == b || a == c || b == c
      in
            if badRandomValues then
              model |> update RandomizeExercise
            else
              ({ model | exercise = Just (newExercise (a,b,c)) }, Cmd.none)


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


newExercise : (String,String,String) -> Exercise
newExercise (a,b,c) =
  let
      target = a++a++a++a++b++b++b++b++a++a++a++a++c++c++c++c++b++b++c++c++a++a++b++b++c++c++b++b++a++b++a++c++a++b
  in
      { target = target
      , userInput = ""
      , progress = 0 }


specialCharacterAt : Int -> String
specialCharacterAt index =
  allCharacters |> String.dropLeft index |> String.left 1


randomCharacterAsString : Random.Generator String
randomCharacterAsString =
  Random.int 0 ((String.length allCharacters) - 1)
  |> Random.map specialCharacterAt


threeRandomCharactersAsStrings : Random.Generator (String,String,String)
threeRandomCharactersAsStrings =
  Random.map3 (\a b c -> (a,b,c)) randomCharacterAsString randomCharacterAsString randomCharacterAsString

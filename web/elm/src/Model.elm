module Model exposing (..)

import Dict exposing (Dict)
import String
import List

import Model.Page exposing (Page(..))

type alias Model =
  { currentPage : Page
  , profile : Profile
  , exercise : Maybe Exercise }

type alias Exercise =
  { target : String
  , userInput : String
  , progress : Int }

type alias Profile =
  Dict Char (List Bool)


initialModel : Model
initialModel =
  { currentPage = Home
  , profile = emptyProfile
  , exercise = Nothing }


emptyProfile : Profile
emptyProfile =
  allCharacters
  |> String.toList
  |> List.foldr (\char dict -> Dict.insert char [] dict) Dict.empty


newExercise : Profile -> Exercise
newExercise profile =
  let
      indexA = 0 -- TODO random numbers
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


allCharacters : String
allCharacters = "(-_=+*!)@£$%^&[]{};:'\"\\`~,./<>?"
